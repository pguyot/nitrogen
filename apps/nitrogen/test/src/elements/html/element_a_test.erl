-module(element_a_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_a_1() ->
  Rec_a = #a{},
  render_test_helper:render_element(Rec_a).

new_a_2() ->
  Rec_a = #a{postback="undefined"},
  render_test_helper:render_element(Rec_a).

new_a_3() ->
  Rec_a = #a{postback="Postback"},
  render_test_helper:render_element(Rec_a).

new_a_4() ->
  Rec_a = #a{body=#image { image="/path/to/image.gif" }},
  render_test_helper:render_element(Rec_a).

new_a_5() ->
  Rec_a = #a{body="A LINK BODY", text="LINK TEXT", html_encode=true, href="not_javascript", postback="mypostback"},
  render_test_helper:render_element(Rec_a).

basic_test_() ->
  [?_assertEqual(<<"<a href=\"javascript:\" class=\"wfid_tempID link\"/>">>, new_a_1()),
   ?_assertEqual(<<"<a href=\"javascript:\" class=\"wfid_tempID link\"/>">>, new_a_2()),
   ?_assertEqual(<<"<a href=\"javascript:\" class=\"wfid_tempID link\"/>">>, new_a_3()),
   ?_assertEqual(<<"<a href=\"javascript:\" class=\"wfid_tempID link\"><img class=\"wfid_tempID image\" src=\"/path/to/image.gif\"/></a>">>, new_a_4()),
   ?_assertEqual(<<"<a href=\"not_javascript\" class=\"wfid_tempID link\">LINK TEXTA LINK BODY</a>">>, new_a_5()),
   ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,text,body, html_encode,href,postback],
	 element_a:reflect())
  ].
