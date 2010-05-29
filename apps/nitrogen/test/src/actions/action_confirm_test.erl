-module (action_confirm_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_confirm_1() ->
    Record = #confirm { text="Do you want to continue?", postback=continue },
    render_test_helper:render_action(Record).

basic_test_() ->
    [
        ?_assertMatch(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');if (confirm(\"Do you want to continue?\")) {Nitrogen.$anchor('.wfid_anchor', '.wfid_anchor');Nitrogen.$queue_event('.wfid_anchor', '", _PickleBinAndRest/binary>>, new_confirm_1())
    ].
