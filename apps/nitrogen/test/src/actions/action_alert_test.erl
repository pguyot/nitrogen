-module (action_alert_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_alert_1() ->
    Record = #alert{text="some_text"},
    render_test_helper:render_action(Record).

basic_test_() ->
    [?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');alert(\"some_text\");">>, new_alert_1())
    ].


