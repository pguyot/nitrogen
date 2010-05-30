-module(element_textarea_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_textarea_1() ->
    Rec_textarea = #textarea{},
    render_test_helper:render_element(Rec_textarea).

new_textarea_2() ->
    Rec_textarea = #textarea{class="t_textarea"},
    render_test_helper:render_element(Rec_textarea).

new_textarea_3() ->
    Rec_textarea = #textarea{class="t_textarea", style="color: cyan;", text="TEXT"},
    render_test_helper:render_element(Rec_textarea).

basic_test_() ->
    [?_assertEqual(<<"<textarea class=\"wfid_tempID textarea\"></textarea>">>,new_textarea_1()),
     ?_assertEqual(<<"<textarea class=\"t_textarea wfid_tempID textarea\"></textarea>">>,new_textarea_2()),
     ?_assertEqual(<<"<textarea class=\"t_textarea wfid_tempID textarea\" style=\"color: cyan;\">TEXT</textarea>">>,new_textarea_3()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,text,html_encode],
	       element_textarea:reflect())
    ].
