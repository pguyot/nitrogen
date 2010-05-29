-module (action_animate_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_animate_1() ->
    Record = #animate{options=[{"key","value"}], speed="a_speed", easing="some_easing"},
    render_test_helper:render_action(Record).

basic_test_() ->
    [?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').animate({ key: 'value' }, \"a_speed\", 'some_easing');">>, 
		   new_animate_1())
    ].
