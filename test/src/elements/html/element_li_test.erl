-module(element_li_test).
-compile([export_all]).

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_li_1() ->
  Rec_li = #li{},
  iolist_to_binary(element_li:render("1",Rec_li)).

new_li_2() ->
  Rec_li = #li{class="t_li"},
  iolist_to_binary(element_li:render("2",Rec_li)).

new_li_3() ->
  Rec_li = #li{class="t_li", style="color: cyan;", text="http://an_li.com/sample/li.jpg"},
  iolist_to_binary(element_li:render("3",Rec_li)).

basic_test_() ->
  [?_assertEqual(<<"<li id=\"1\" class=\"listitem\"/>">>,new_li_1()),
   ?_assertEqual(<<"<li id=\"2\" class=\"listitem t_li\"/>">>,new_li_2()),
   ?_assertEqual(<<"<li id=\"3\" class=\"listitem t_li\" style=\"color: cyan;\">http://an_li.com/sample/li.jpg</li>">>,new_li_3()),
   ?_assertEqual([module,id,actions,show_if,class,style,title,attrs,body,text,html_encode],
	 element_li:reflect())
  ].
