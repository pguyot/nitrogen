-module (action_appear_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_appear_1() ->
    Record = #appear{speed="a_speed"},
    render_test_helper:render_action(Record).

basic_test_() ->
    [?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').fadeIn(\"a_speed\");">>,
		   new_appear_1())
    ].
