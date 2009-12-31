-module(element_a_test).
-compile([export_all]).

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_a_1() ->
  Rec_a = #a{},
  lists:flatten(element_a:render("1",Rec_a)).

new_a_2() ->
  Rec_a = #a{postback="undefined"},
  lists:flatten(element_a:render("2",Rec_a)).

new_a_3() ->
  Rec_a = #a{postback="Postback"},
  lists:flatten(element_a:render("3",Rec_a)).

new_a_4() ->
  Rec_a = #a{body=#image { image="/path/to/image.gif" }},
  lists:flatten(element_a:render("4",Rec_a)).

new_a_5() ->
  Rec_a = #a{body="A LINK BODY", text="LINK TEXT", html_encode=true, href="not_javascript", postback="mypostback"},
  lists:flatten(element_a:render("5",Rec_a)).

basic_test_() ->
  [?_assertEqual("<a id=\"1\" href=\"javascript:\" class=\"link\"/>", new_a_1()),
   ?_assertEqual("<a id=\"2\" href=\"javascript:\" class=\"link\"/>", new_a_2()),
   ?_assertEqual("<a id=\"3\" href=\"javascript:\" class=\"link\"/>", new_a_3()),
   ?_assert(eunit_helper:regexpMatch("<a id=\"4\" href=\"javascript:\" class=\"link\"><img id=\".*?\" class=\"image\" src=\"/path/to/image.gif\"/></a>",
                                     new_a_4())),
   ?_assertEqual("<a id=\"5\" href=\"not_javascript\" class=\"link\">LINK&nbsp;TEXTA LINK BODY</a>", new_a_5()),
   ?_assertEqual([module,id,actions,show_if,class,style,title,attrs,text,body, html_encode,href,postback],
	 element_a:reflect())
  ].
