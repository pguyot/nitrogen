% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_template).
-include ("wf.inc").
-export([render/2, reflect/0]).

% TODO - Revisit parsing in the to_module_callback. This
% will currently fail if we encounter a string like:
% "String with ) will fail" 
% or 
% "String with ]]] will fail"

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, template).

-spec(render/2::(wf_id(), #template{}) -> iodata()).
render(_ControlID, Record) ->
	% Prevent loops.
	case wf:state(template_was_called) of
		true -> throw("Calling a template from a template.");
		_ -> ignore
	end,
	wf:state(template_was_called, true),
	
	% Parse the template file, or read it from cache.
	File = wf:to_list(Record#template.file),
	Template = parse_template(File),
	
	% IN PROGRESS - Caching
	% Key = {template, File},
	% Template = wf_cache:cache(Key, fun() -> parse_template(File) end, [{ttl, 5}]),
	
	% Evaluate the template.
	Body = eval(Template, Record),
	
	IsWindexMode = wf:q(windex) == ["true"],
	case IsWindexMode of
		true ->	[
			wf:f("Nitrogen.$lookup('~s').$update(\"~s\");", [get(current_id), wf_utils:js_escape(Body)])
		];
		false -> Body
	end.


%-spec(parse_template/1::(string()) -> [iodata()|script|{atom(), atom(), string()}]).
parse_template(File) ->
	File1 = filename:join(nitrogen:get_templateroot(), File),
	case file:read_file(File1) of
		{ok, B} -> parse(B);
		{error, Reason} -> 
			?LOG("Error reading file: ~s (~p)~n", [File1, Reason]),
			[]
	end.	

%%% PARSE %%%
	
%% parse/2 - Given a binary, look through the binary
%% for strings of the form [[[module]]] or [[[module:function(args)]]]
%% Remark: the previous implementation also allowed placeholders like [[[module:function(args),module:function(args),...]]]
%% These are not documented and support for those has been removed.
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

to_term(X, Bindings) ->
	S = wf:to_list(X),
	{ok, Tokens, 1} = erl_scan:string(S),
	{ok, Exprs} = erl_parse:parse_exprs(Tokens),
	{value, Value, _} = erl_eval:exprs(Exprs, Bindings),
	Value.



%%% EVALUATE %%%

eval(List, Record) ->
    lists:map(fun(Item) ->
        if
            Item =:= script -> wf_script:get_script();
            ?IS_STRING(Item) -> Item;
            is_binary(Item) -> Item;
            is_tuple(Item) -> eval_callback(Item, Record)
        end
    end, List).
	
eval_callback({M, Function, ArgString}, Record) ->
	% De-reference to page module...
	Module = case M of 
		page -> wf_platform:get_page_module();
		_ -> M
	end,

	% Convert args to term...
	Args = to_term(["[", ArgString, "]."], Record#template.bindings),
	
	code:ensure_loaded(Module),
	case erlang:function_exported(Module, Function, length(Args)) of
		false -> 
			% Function is not defined, return the empty list
			% (to preserve backward compatibility)
			% Also log, as it is a bug.
			?LOG("Error evaluating callback ~p:~p/~p : function not defined~n", [Module, Function, length(Args)]),
			[];
			
		true ->
			case erlang:apply(Module, Function, Args) of
				undefined -> 
					% Function returns undefined, return the empty list
					[];

				Data ->
					% Got some data. Render it if necessary.
					case wf:is_string(Data) of
						true -> Data;
						false -> wf:render(Data)
					end
			end
	end.
