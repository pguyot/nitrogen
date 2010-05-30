-module(element_value_test).
-author("michael@mulpechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_value_1() ->
    Rec_value = #value{},
    render_test_helper:render_element(Rec_value).

new_value_2() ->
    Rec_value = #value{class="t_value"},
    render_test_helper:render_element(Rec_value).

new_value_3() ->
    Rec_value = #value{class="t_value", style="color: cyan;", text="TEXT"},
    render_test_helper:render_element(Rec_value).

basic_test_() ->
    [?_assertEqual(<<"<span class=\"wfid_tempID value\"></span>">>,new_value_1()),
     ?_assertEqual(<<"<span class=\"t_value wfid_tempID value\"></span>">>,new_value_2()),
     ?_assertEqual(<<"<span class=\"t_value wfid_tempID value\" style=\"color: cyan;\">TEXT</span>">>,new_value_3()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,text,html_encode],
	 element_value:reflect())
    ].
