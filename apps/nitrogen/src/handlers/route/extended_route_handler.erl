% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% Copyright (c) 2010 Semiocast
% See MIT-LICENSE for licensing information.

-module (extended_route_handler).
-behaviour (route_handler).
-include_lib ("wf.hrl").
-export ([
    init/2, 
    finish/2
]).

% Type used for configuration.
-type route() ::
            {string(), module()}
        |   {string(), static_file}
        |   {string(), static_file, string()}
        |   {string(), redirect, string()}
        |   {string(), redirect, string(), redirect_status()}.

% Internal type.
-type resolved_route() :: {static_file, string()} | {static_file, string(), string()} | {module, module(), string()} | {redirect, integer(), string()}.
-type redirect_status() :: permanent | temp | seeother | integer().

%% @doc
%% The extended route handler is an extension of the named route handler.
%% It allows redirections and static files to a specific document root.
%%
%% Here is a usage example:
%%
%% &lt;pre&gt;
%%	wf_handler:set_handler(extended_route_handler, [
%%        {"/downloads", static_file, "/path/to/downloads"},
%%        {"/static/(.+)$", redirect, "/\\1"},
%%        {"^.*/moved/path(.+)$", redirect, "http://otherserver.com/\\1", permanent},
%%
%%        % Static directories...
%%        {"/nitrogen", static_file},
%%        {"/js", static_file},
%%        {"/images", static_file},
%%        {"/css", static_file},
%%
%%        % Modules...
%%        {"/view", web_view},
%%        {"/img", web_img},
%%
%%        % Default route.
%%        {"/", web_index}
%%  ])
%% &lt;/pre&gt;
%%
%% While the configuration format is an extension of named_route_handler's
%% configuration, there are few differences:
%% - rules are processed in configuration order
%% - if no rules match, the request is passed to web_404 module (instead of
%% being converted to a static file)
%% - module and static_file routes insists
%% to get a slash separator, except if the path is equal to the prefix.
%% For example :
%% "/foobar" will not match {"/foo", _}
%% "/foo/bar" will match {"/foo", _}, and for compatibility reason, path_info is set to "/bar"
%% "/foo/bar" will match {"/foo/", _}, and path_info will be set to "bar"
%% "/robots.txt" will match {"/robots.txt", _}
%%

init(undefined, State) -> init([], State);
init(Routes, State) -> 
    % Get the path...
    RequestBridge = wf_context:request_bridge(),
    Path = RequestBridge:path(),

    {PageModule, PathInfo} = route(Path, Routes),
    wf_context:page_module(PageModule),
    wf_context:path_info(PathInfo),
    {ok, State}.

finish(_Config, State) -> 
    {ok, State}.

%%% PRIVATE FUNCTIONS %%%

route(Path, Routes) ->
    case resolve_route(Path, Routes) of
        {static_file, StaticFilePath} ->
            {static_file, StaticFilePath};
        {static_file, DocRoot, StaticFilePath} ->
            {{static_file, DocRoot}, StaticFilePath};
        {module, Module, SubPath} ->
            case code:ensure_loaded(Module) of
                {module, Module} ->
                    {Module, SubPath};
                _ ->
                    {get_404_module(), Path}
            end;
        {redirect, Code, RedirectURI} ->
            {{redirect, Code}, RedirectURI}
    end.

% @doc Iterate through the routes until the first one that matches. If no routes
% matche, return the 404 route.
-spec resolve_route(string(), [route()]) -> resolved_route().
resolve_route(Path, []) ->
    {module, get_404_module(), Path};
resolve_route(Path, [Route | Tail]) ->
    case resolve(Path, Route) of
        {value, Result} -> Result;
        false -> resolve_route(Path, Tail)
    end.

-spec resolve(string(), route()) -> {value, resolved_route()} | false.
resolve(Path, {Path, static_file}) -> {value, {static_file, Path}};
resolve(Path, {Prefix, static_file}) ->
    case matches_prefix(Path, Prefix) of
        true -> {value, {static_file, Path}};
        false -> false
    end;
resolve(Path, {Path, Module}) -> {value, {module, Module, []}};
resolve(Path, {Prefix, Module}) ->
    case extract_suffix(Path, Prefix) of
        {value, Suffix} ->
            {value, {module, Module, Suffix}};
        false -> false
    end;
resolve(Path, {Path, static_file, DocRoot}) -> {value, {static_file, DocRoot, []}};
resolve(Path, {Prefix, static_file, DocRoot}) ->
    case extract_suffix(Path, Prefix) of
        {value, Suffix} ->
            {value, {static_file, DocRoot, Suffix}};
        false -> false
    end;
resolve(_Path, {Regex, redirect, Replacement}) ->
    resolve_redirect(302, Regex, Replacement);
resolve(_Path, {Regex, redirect, Replacement, Code}) ->
    resolve_redirect(Code, Regex, Replacement).

-spec resolve_redirect(redirect_status(), iodata(), iodata()) -> {value, {redirect, integer(), string()}} | false.
resolve_redirect(RedirectStatus, Regex, Replacement) ->
    RequestBridge = wf_context:request_bridge(),
    URI = RequestBridge:uri(),
    {ok, RegexC} = re:compile(Regex),
    case re:run(URI, RegexC, [{capture, none}]) of
        match ->
            RedirectURI = re:replace(URI, RegexC, Replacement, [{return, list}]),
            Code = redirect_status_to_code(RedirectStatus),
            {value, {redirect, Code, RedirectURI}};
        nomatch -> false
    end.

-spec redirect_status_to_code(redirect_status()) -> integer().
redirect_status_to_code(Code) when is_integer(Code) -> Code;
redirect_status_to_code(permanent) -> 301;
redirect_status_to_code(temp) -> 302;
redirect_status_to_code(seeother) -> 303.

-spec matches_prefix(string(), string()) -> boolean().
matches_prefix(Path, Prefix) ->
    NPrefix = normalize_prefix(Prefix),
    1 =:= string:str(Path, NPrefix).

-spec normalize_prefix(string()) -> string().
normalize_prefix(Prefix) ->
    case lists:last(Prefix) of
        $/ -> Prefix;
        _ -> lists:append(Prefix, "/")
    end.

-spec extract_suffix(string(), string()) -> {value, string()} | false.
extract_suffix(Path, Prefix) ->
    case matches_prefix(Path, Prefix) of
        true ->
            Suffix = string:substr(Path, length(Prefix) + 1),
            {value, Suffix};
        false -> false
    end.

% Try to load the (user-configurable) web_404 page. If that is not available,
% then default to the 'file_not_found_page' module.
-spec get_404_module() -> module().
get_404_module() ->
    Web404Module = wf:config_default(web_404, web_404),
    case code:ensure_loaded(Web404Module) of
        {module, Web404Module} -> Web404Module;
        _ -> file_not_found_page
    end.
