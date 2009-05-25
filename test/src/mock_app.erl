-module (mock_app).

-author("michael@mullistechnologies.com").

-include ("wf.inc").
-compile(export_all).


-include_lib("eunit/include/eunit.hrl").

start(_, _) ->
  process_flag(trap_exit, true),
  Result = nitrogen:start(),
  %io:format("appl = ~p~n",[application:get_application()]),
  register(mock_app, spawn_link(mock_app,loop,[])),
  Result.

stop(_) -> nitrogen:stop(mock_app).

route(Path) -> nitrogen:route(Path).

request(Module) ->
	nitrogen:request(Module).

loop() ->
  receive
    {'EXIT', From, Reason} ->
      io:format("mock_app: Received unexpected EXIT - From: ~p  Reason: ~p~n",[From, Reason]),
      loop();
    {action_comet_start, From} ->
      %io:format("mock_app: Received action_comet_start~n",[]),
      Response = action_comet_start_test:new_comet_start_1(),
      From ! {action_comet_start_response, Response},
      loop();
    {action_confirm, From} ->
      Response = action_confirm_test:new_confirm_1(),
      From ! {action_confirm_response, Response},
      loop();
    Other ->
      io:format("mock_app: Received unexpected message ~p~n",[Other]),
      loop()
  end.
