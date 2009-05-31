-module (action_confirm_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_confirm_1() ->
    Record = #confirm { text="Do you want to continue?", postback=continue },
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    lists:flatten(action_confirm:render_action(TriggerPath, TargetPath, Record)).

result_1() ->
    mock_app ! {action_confirm, self()},
    receive
	{action_confirm_response, Response} ->
	    Response;
	_ -> {error}
    
    end.

test_1() ->
    eunit_helper:regexpMatch("Do you want to continue", result_1()).


basic_test_() ->
    [?_assertEqual(true,
		   test_1())
    ].
