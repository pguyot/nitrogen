-module(element_list_test).
-author("michael@mulpechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_list_1() ->
    Rec_list = #list{},
    render_test_helper:render_element(Rec_list).

new_list_2() ->
    Rec_list = #list{class="t_list"},
    render_test_helper:render_element(Rec_list).

new_list_3() ->
    Rec_list = #list{class="t_list", style="color: cyan;", body="SOME BODY"},
    render_test_helper:render_element(Rec_list).

new_list_4() ->
    Rec_list = #list{numbered=true},
    render_test_helper:render_element(Rec_list).

new_list_5() ->
    Rec_list = #list{numbered=true, class="t_list"},
    render_test_helper:render_element(Rec_list).

new_list_6() ->
    Rec_list = #list{class="t_list", style="color: cyan;", numbered=true, body="SOME BODY"},
    render_test_helper:render_element(Rec_list).

basic_test_() ->
    [
     ?_assertEqual(<<"<ul class=\"wfid_tempID list\"/>">>,new_list_1()),
     ?_assertEqual(<<"<ul class=\"t_list wfid_tempID list\"/>">>,new_list_2()),
     ?_assertEqual(<<"<ul class=\"t_list wfid_tempID list\" style=\"color: cyan;\">SOME BODY</ul>">>,new_list_3()),
     ?_assertEqual(<<"<ol class=\"wfid_tempID list\"/>">>,new_list_4()),
     ?_assertEqual(<<"<ol class=\"t_list wfid_tempID list\"/>">>,new_list_5()),
     ?_assertEqual(<<"<ol class=\"t_list wfid_tempID list\" style=\"color: cyan;\">SOME BODY</ol>">>,new_list_6()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,numbered,body],
           element_list:reflect())
    ].
