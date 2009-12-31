% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (nitrogen_mochiweb_app).
-export([start/0, stop/0]).
-include ("wf.inc").
-export([loop/3]).

start() ->
	% Initialize Nitrogen.
	wf:init(),

	% Start the Mochiweb server.
	Ip = nitrogen:get_ip(),
	Port = nitrogen:get_port(),
	DocumentRoot = nitrogen:get_wwwroot(),
	IndexModule = nitrogen:get_index_module(),
	Options = [{ip, Ip}, {port, Port}],
	HooksModule = nitrogen:get_hooks_module(),
	case erlang:function_exported(HooksModule, loop, 3) of
	    true ->
		Loop = fun(Req) -> HooksModule:loop(Req, DocumentRoot, IndexModule) end;
	    false ->
            case erlang:function_exported(HooksModule, loop, 2) of
                true ->
                Loop = fun(Req) -> HooksModule:loop(Req, DocumentRoot) end;
                false ->
                Loop = fun(Req) -> ?MODULE:loop(Req, DocumentRoot, IndexModule) end
            end
    end,
	mochiweb_http:start([{name, get_name()}, {loop, Loop} | Options]).

loop(Req, DocRoot, IndexModule) ->
	"/" ++ Path = Req:get(path),
	case Req:get(method) of
		Method when Method =:= 'GET'; Method =:= 'HEAD' ->
			case Path of
				"" -> wf_mochiweb:loop(Req, IndexModule);
				"web/" ++ _ -> wf_mochiweb:loop(Req);
				_ -> Req:serve_file(Path, DocRoot)
			end;
			
		'POST' ->
			case Path of
				"" -> wf_mochiweb:loop(Req, IndexModule);
				"web/" ++ _ -> wf_mochiweb:loop(Req);
				_ -> Req:not_found()
			end;
		_ ->
		Req:respond({501, [], []})
	end.
	
stop() -> 
	% Stop the mochiweb server.
	mochiweb_http:stop(get_name()),
	ok.
	
get_name() ->
	case application:get_application() of
		{ok, App} -> App;
		undefined -> nitrogen
	end.
