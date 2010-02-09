-module(element_textbox_test).
-compile([export_all]).

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_textbox_1() ->
    Rec_textbox = #textbox{},
    iolist_to_binary(element_textbox:render("1",Rec_textbox)).

new_textbox_2() ->
    Rec_textbox = #textbox{class="t_textbox"},
    iolist_to_binary(element_textbox:render("2",Rec_textbox)).

new_textbox_3() ->
    Rec_textbox = #textbox{class="t_textbox", style="color: cyan;", text="TEXT"},
    iolist_to_binary(element_textbox:render("3",Rec_textbox)).

new_textbox_4() ->
    Rec_textbox = #textbox{class="t_textbox", style="color: cyan;", text="TEXT", type=email},
    iolist_to_binary(element_textbox:render("4",Rec_textbox)).

basic_test_() ->
    [?_assertEqual(<<"<input id=\"1\" name=\"1\" type=\"text\" class=\"textbox\"/>">>,new_textbox_1()),
     ?_assertEqual(<<"<input id=\"2\" name=\"2\" type=\"text\" class=\"textbox t_textbox\"/>">>,new_textbox_2()),
     ?_assertEqual(<<"<input id=\"3\" name=\"3\" type=\"text\" class=\"textbox t_textbox\" style=\"color: cyan;\" value=\"TEXT\"/>">>,new_textbox_3()),
     ?_assertEqual(<<"<input id=\"4\" name=\"4\" type=\"email\" class=\"textbox t_textbox\" style=\"color: cyan;\" value=\"TEXT\"/>">>,new_textbox_4()),
     ?_assertEqual([module,id,actions,show_if,class,style,title,attrs,text,html_encode,type,next,postback],
	       element_textbox:reflect())
    ].
