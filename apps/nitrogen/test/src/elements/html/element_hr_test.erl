-module(element_hr_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_hr_1() ->
    Rec_hr = #hr{},
    render_test_helper:render_element(Rec_hr).

new_hr_2() ->
    Rec_hr = #hr{class="t_hr"},
    render_test_helper:render_element(Rec_hr).

new_hr_3() ->
    Rec_hr = #hr{class="t_hr", style="color: cyan;"},
    render_test_helper:render_element(Rec_hr).

basic_test_() ->
    [?_assertEqual(<<"<hr size=\"1\" class=\"wfid_tempID hr\"/>">>,new_hr_1()),
     ?_assertEqual(<<"<hr size=\"1\" class=\"t_hr wfid_tempID hr\"/>">>,new_hr_2()),
     ?_assertEqual(<<"<hr size=\"1\" class=\"t_hr wfid_tempID hr\" style=\"color: cyan;\"/>">>,new_hr_3()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs],
	       element_hr:reflect())
    ].
