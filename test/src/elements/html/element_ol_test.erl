-module(element_ol_test).
-compile([export_all]).

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_ol_1() ->
  Rec_ol = #ol{},
  lists:flatten(element_ol:render("1",Rec_ol)).

new_ol_2() ->
  Rec_ol = #ol{class="t_ol"},
  lists:flatten(element_ol:render("2",Rec_ol)).

new_ol_3() ->
  Rec_ol = #ol{class="t_ol", style="color: cyan;", body="SOME BODY"},
  lists:flatten(element_ol:render("3",Rec_ol)).

basic_test_() ->
  [
   ?_assertEqual("<ol id=\"1\" class=\"list\"/>",new_ol_1()),
   ?_assertEqual("<ol id=\"2\" class=\"list t_ol\"/>",new_ol_2()),
   ?_assertEqual("<ol id=\"3\" class=\"list t_ol\" style=\"color: cyan;\">SOME BODY</ol>",new_ol_3()),
   ?_assertEqual([module,id,actions,show_if,class,style,title,attrs,body],
	 element_ol:reflect())
  ].
