-module (mock_app).

-author("michael@mullistechnologies.com").

-include ("wf.inc").
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

start(_, _) ->
  Result = nitrogen:start(),
  %io:format("appl = ~p~n",[application:get_application()]),
  MockAppPid = spawn_link(mock_app,loop,[]),
  register(mock_app, MockAppPid),
  Result.

stop(_) -> nitrogen:stop(mock_app).

route(Path) -> nitrogen:route(Path).

request(Module) ->
	nitrogen:request(Module).

loop() ->
  receive
    {action_comet_start, From} ->
      %io:format("Received action_comet_start~n",[]),
      Response = action_comet_start_test:new_comet_start_1(),
      From ! {action_comet_start_response, Response},
      loop();
    {action_confirm, From} ->
      Response = action_confirm_test:new_confirm_1(),
      From ! {action_confirm_response, Response},
      loop();
    _ ->
      loop()
  end.
