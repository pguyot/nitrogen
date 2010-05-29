-module (action_add_class_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_add_class_1() ->
    Record = #add_class{class="a_class", speed="a_speed"},
    render_test_helper:render_action(Record).

basic_test_() ->
    [?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').addClass('a_class', \"a_speed\");">>,
		   new_add_class_1())
    ].
