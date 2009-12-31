% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (wf_inets).
-include ("httpd.hrl").
-export ([do/1]).
	
do(Info) ->
	wf_platform:init(wf_platform_inets, Info),
	{Path, _QueryString} = httpd_util:split_path(Info#mod.request_uri),
	case Path of
		"/" ->
		    IndexModule = nitrogen:get_index_module(),
		    do(Info, IndexModule);
		"/web" ++ _ ->
        	{Module, PathInfo} = wf_platform:route(Path),
		    do(Info, Module, PathInfo);
		_ -> {proceed, Info#mod.data}
	end.
	
do(Info, Module) -> do(Info, Module, "").
	
do(Info, Module, PathInfo) ->	
	wf_platform:init(wf_platform_inets, Info),
	try wf_handle:handle_request(Module, PathInfo)
	catch Type : Error ->
		io:format("CAUGHT ERROR: ~p-~p~n~p~n", [Type, Error, erlang:get_stacktrace()]),
		{proceed, Info#mod.data}
	end.
