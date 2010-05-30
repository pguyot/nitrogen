-module(element_textbox_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_textbox_1() ->
    Rec_textbox = #textbox{},
    render_test_helper:render_element(Rec_textbox).

new_textbox_2() ->
    Rec_textbox = #textbox{class="t_textbox"},
    render_test_helper:render_element(Rec_textbox).

new_textbox_3() ->
    Rec_textbox = #textbox{class="t_textbox", style="color: cyan;", text="TEXT"},
    render_test_helper:render_element(Rec_textbox).

new_textbox_4() ->
    Rec_textbox = #textbox{class="t_textbox", style="color: cyan;", text="TEXT", type=email},
    render_test_helper:render_element(Rec_textbox).

basic_test_() ->
    [?_assertEqual(<<"<input type=\"text\" class=\"wfid_tempID textbox\" value=\"\"/>">>,new_textbox_1()),
     ?_assertEqual(<<"<input type=\"text\" class=\"t_textbox wfid_tempID textbox\" value=\"\"/>">>,new_textbox_2()),
     ?_assertEqual(<<"<input type=\"text\" class=\"t_textbox wfid_tempID textbox\" style=\"color: cyan;\" value=\"TEXT\"/>">>,new_textbox_3()),
     ?_assertEqual(<<"<input type=\"email\" class=\"t_textbox wfid_tempID textbox\" style=\"color: cyan;\" value=\"TEXT\"/>">>,new_textbox_4()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,text,html_encode,type,next,postback,delegate],
	       element_textbox:reflect())
    ].
