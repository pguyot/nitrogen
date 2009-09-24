-module (quickstart_inets_app).
-include ("wf.inc").

-export ([start/2, stop/0, do/1]).

-define (PORT, 8000).

start(_, _) ->
	default_process_cabinet_handler:start(),
	inets:start(),
	{ok, Pid} = inets:start(httpd, [
		{port, ?PORT},
		{server_name, "nitrogen"},
		{server_root, "."},
		{document_root, "./wwwroot"},
		{modules, [?MODULE]},
		{mime_types, [{"css", "text/css"}, {"js", "text/javascript"}, {"html", "text/html"}]}
	]),
	link(Pid),
	{ok, Pid}.
	
stop() ->
	httpd:stop_service({any, ?PORT}),
	ok.
	
do(Info) ->
	RequestBridge = simple_bridge:make_request(inets_request_bridge, Info),
	ResponseBridge = simple_bridge:make_response(inets_response_bridge, Info),
	nitrogen:init_request(RequestBridge, ResponseBridge),
	% wf_handler:set_handler(route_handler, default_route_handler, []),
	nitrogen:run().