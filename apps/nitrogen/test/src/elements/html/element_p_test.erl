-module(element_p_test).
-author("michael@mulpechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_p_1() ->
    Rec_p = #p{},
    render_test_helper:render_element(Rec_p).

new_p_2() ->
    Rec_p = #p{class="t_p"},
    render_test_helper:render_element(Rec_p).

new_p_3() ->
    Rec_p = #p{class="t_p", style="color: cyan;"},
    render_test_helper:render_element(Rec_p).

basic_test_() ->
    [?_assertEqual(<<"<p class=\"wfid_tempID p\"/>">>,new_p_1()),
     ?_assertEqual(<<"<p class=\"t_p wfid_tempID p\"/>">>,new_p_2()),
     ?_assertEqual(<<"<p class=\"t_p wfid_tempID p\" style=\"color: cyan;\"/>">>,new_p_3()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,body],
           element_p:reflect())
    ].
