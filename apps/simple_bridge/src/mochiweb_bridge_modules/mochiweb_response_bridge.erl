% Simple Bridge
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (mochiweb_response_bridge).
-behaviour (simple_bridge_response).
-include_lib ("simple_bridge.hrl").
-export ([build_response/2]).

build_response({Req, DocRoot}, Res) ->	
    case Res#response.data of
        {data, Body} ->
            Code = Res#response.statuscode,
            % Assemble headers...
            Headers = lists:flatten([
                [{X#header.name, X#header.value} || X <- Res#response.headers],
                [create_cookie_header(X) || X <- Res#response.cookies]
            ]),		

            % Ensure content type...
            F = fun(Key) -> lists:keymember(Key, 1, Headers) end,
            HasContentType = lists:any(F, ["content-type", "Content-Type", "CONTENT-TYPE"]),
            case HasContentType of
                true -> Headers2 = Headers;
                false -> Headers2 = [{"Content-Type", "text/html"}]
            end,

            % Send the mochiweb response...
            Req:respond({Code, Headers2, Body});
        {file, Path, Options0} ->
            Options = case proplists:is_defined(docroot, Options0) of
                true -> Options0;
                false -> [{docroot, DocRoot} | Options0]
            end,
            serve_file(Req, Path, Options);
        {file, Path} ->
            serve_file(Req, Path, [{docroot, DocRoot}])
    end.

create_cookie_header(Cookie) ->
    SecondsToLive = Cookie#cookie.minutes_to_live * 60,
    Name = Cookie#cookie.name,
    Value = Cookie#cookie.value,
    Path = Cookie#cookie.path,
    mochiweb_cookies:cookie(Name, Value, [{path, Path}, {max_age, SecondsToLive}]).

serve_file(Req, Path, Options) ->
    Headers = simple_bridge_response:serve_file_headers(Path, Options),
    DocRoot = proplists:get_value(docroot, Options),
    Req:serve_file(tl(Path), DocRoot, Headers).
