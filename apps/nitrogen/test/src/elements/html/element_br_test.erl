-module(element_br_test).
-author("michael@mulpechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_br_1() ->
    Rec_br = #br{},
    render_test_helper:render_element(Rec_br).

new_br_2() ->
    Rec_br = #br{class="t_br"},
    render_test_helper:render_element(Rec_br).

new_br_with_style() ->
    Rec_br = #br{class="t_br", style="color: cyan;"},
    render_test_helper:render_element(Rec_br).

basic_test_() ->
    [?_assertEqual(<<"<br class=\"wfid_tempID br\"/>">>,new_br_1()),
     ?_assertEqual(<<"<br class=\"t_br wfid_tempID br\"/>">>,new_br_2()),
     ?_assertEqual(<<"<br class=\"t_br wfid_tempID br\" style=\"color: cyan;\"/>">>,new_br_with_style()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs],
	       element_br:reflect())
    ].
