% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_template).
-include_lib ("wf.hrl").
-export([render_element/1, reflect/0, parse/1, eval/2]).

-type parsed_template() :: [script|iodata()|{atom(), atom(), string()}].

-spec reflect() -> [atom()].
reflect() -> record_info(fields, template).

-spec render_element(#template{}) -> wf_render_data().
render_element(Record) ->
    % Parse the template file...
    
    File = wf:to_list(Record#template.file),
    Template = get_cached_template(File),

    % Set the content type (this can be overridden in evaluations)
    wf:content_type(Record#template.mime_type),

    % Evaluate the template.
    Body = eval(Template, Record#template.bindings),
    Body.

get_cached_template(File) ->
    RelPath = filename:join(wf:config_default(templateroot, "."), File),
    FullPath = filename:absname(RelPath),
    FileAtom = list_to_atom("template_file_" ++ FullPath),

    LastModAtom = list_to_atom("template_lastmod_" ++ FullPath),
    LastMod = mochiglobal:get(LastModAtom),

    CacheTimeAtom = list_to_atom("template_cachetime_" ++ FullPath),
    CacheTime = mochiglobal:get(CacheTimeAtom),
    
    %% Check for recache if one second has passed since last cache time...
    ReCache = case (CacheTime == undefined) orelse (timer:now_diff(now(), CacheTime) > (1000 * 1000)) of
        true -> 
            %% Recache if the file has been modified. Otherwise, reset
            %% the CacheTime timer...
            case LastMod /= filelib:last_modified(File) of
                true -> 
                    true;
                false ->
                    mochiglobal:put(CacheTimeAtom, now()),
                    false
            end;
        false ->
            false
    end,
    
    case ReCache of
        true ->
            %% Recache the template...
            Template = parse_template(File),
            mochiglobal:put(FileAtom, Template),
            mochiglobal:put(LastModAtom, filelib:last_modified(File)),
            mochiglobal:put(CacheTimeAtom, now()),
            Template;
        false ->
            %% Load template from cache...
            mochiglobal:get(FileAtom)
    end.

-spec parse_template(string()) -> parsed_template().
parse_template(File) ->
    File1 = filename:join(wf:config_default(templateroot, "."), File),
	case file:read_file(File1) of
		{ok, B} -> parse(B);
		{error, Reason} -> 
			?LOG("Error reading file: ~s (~p)~n", [File1, Reason]),
			[]
	end.

%%% PARSE %%%

%% parse/1 - Given a binary, look through the binary
%% for strings of the form [[[module]]] or [[[module:function(args)]]]
%% Remark: the previous implementation also allowed placeholders like [[[module:function(args),module:function(args),...]]]
%% These are not documented and support for those has been removed.
-spec parse(binary()) -> parsed_template().
parse(Binary) ->
    case re:run(Binary, <<"\\[\\[\\[([a-z0-9_]+)(:([a-z0-9_]+)\\((.*?)\\))?\\]\\]\\]">>, [global]) of
        nomatch -> [Binary];
        {match, Captured} ->
            {_, FinalRest, Parsed} = lists:foldl(fun([{BracketsS, BracketsEnd}, {ModuleLeft, ModuleLen} | FunctionCaptured], {Index, Rest, Acc}) ->
                NewAcc0 = if
                    BracketsS =:= 0 -> Acc;
                    BracketsS > 0 ->
                        {Left, _} = split_binary(Rest, BracketsS - Index),
                        [Left | Acc]
                end,
                NewIndex = BracketsS + BracketsEnd,
                {_, NewRest} = split_binary(Rest, NewIndex - Index),
                {_, PlaceholderModule0} = split_binary(Rest, ModuleLeft - Index),
                {PlaceholderModuleBin, _} = split_binary(PlaceholderModule0, ModuleLen),
                PlaceholderModule = wf:to_atom(PlaceholderModuleBin),
                PlaceholderParsedData = case FunctionCaptured of
                    [] ->
                        PlaceholderModule;
                    [{_FunctionCapturedLeft, _FunctionCapturedLen}, {FunctionLeft, FunctionLen}, {ArgsLeft, ArgsLen}] ->
                        {_, FunctionStr0} = split_binary(Rest, FunctionLeft - Index),
                        {FunctionStr, _} = split_binary(FunctionStr0, FunctionLen),
                        {_, ArgsStr0} = split_binary(Rest, ArgsLeft - Index),
                        {ArgsStr, _} = split_binary(ArgsStr0, ArgsLen),
                        Function = wf:to_atom(FunctionStr),
                        {PlaceholderModule, Function, ArgsStr}
                end,
                {NewIndex, NewRest, [PlaceholderParsedData | NewAcc0]}
            end, {0, Binary, []}, Captured),
            lists:reverse([FinalRest | Parsed])
    end.

-spec to_term(string(), [{atom(), any()}]) -> any().
to_term(S, Bindings) ->
    {ok, Tokens, 1} = erl_scan:string(S),
    {ok, Exprs} = erl_parse:parse_exprs(Tokens),
    {value, Value, _} = erl_eval:exprs(Exprs, Bindings),
    Value.



%%% EVALUATE %%%

-spec eval(parsed_template(), [{atom(), any()}]) -> wf_render_data().
eval(List, Bindings0) ->
	Bindings = lists:foldl(fun({Key, Value}, Acc) ->
		erl_eval:add_binding(Key, Value, Acc)
	end, erl_eval:new_bindings(), Bindings0),
    lists:map(fun(Item) ->
        if
            Item =:= script -> script;
            ?IS_STRING(Item) -> Item;
            is_binary(Item) -> Item;
            is_tuple(Item) -> replace_callback(Item, Bindings)
        end
    end, List).

% Turn a callback into a reference to #function_el {}.
replace_callback({Module, Function, ArgString}, Bindings) ->
    EvalFunction = convert_callback_tuple_to_function(Module, Function, ArgString, Bindings),
    #function_el { anchor=page, function=EvalFunction }.

convert_callback_tuple_to_function(Module, Function, ArgString, Bindings) ->
    % De-reference to page module...
    Module1 = case Module of 
        page -> wf_context:page_module();
        _ -> Module
    end,

    _F = fun() ->
        % Convert args to term...
        Args = to_term(wf:to_list(["[", ArgString, "]."]), Bindings),

        % If the function in exported, then call it. 
        % Otherwise return undefined...
        {module, Module1} = code:ensure_loaded(Module1),
        case erlang:function_exported(Module1, Function, length(Args)) of
            true -> _Elements = erlang:apply(Module1, Function, Args);
            false -> undefined
        end
    end.
