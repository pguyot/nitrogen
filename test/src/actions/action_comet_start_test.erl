-module (action_comet_start_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_comet_start_1() ->
    Record = #comet_start{},
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    lists:flatten(action_comet_start:render_action(TriggerPath, TargetPath, Record)).

result_1() ->
    mock_app ! {action_comet_start, self()},
    receive
	{action_comet_start_response, Response} ->
	    Response;
	_ -> {error}
    
    end.

test_1() ->
    eunit_helper:regexpMatch("Nitrogen\\\.\\\$comet_start", result_1()).

basic_test_() ->
    [?_assertEqual(true,test_1())
    ].
