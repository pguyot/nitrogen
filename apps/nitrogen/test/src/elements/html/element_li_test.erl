-module(element_li_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_li_1() ->
  Rec_li = #li{},
  render_test_helper:render_element(Rec_li).

new_li_2() ->
  Rec_li = #li{class="t_li"},
  render_test_helper:render_element(Rec_li).

new_li_3() ->
  Rec_li = #li{class="t_li", style="color: cyan;", text="http://an_li.com/sample/li.jpg"},
  render_test_helper:render_element(Rec_li).

basic_test_() ->
  [?_assertEqual(<<"<li class=\"wfid_tempID listitem\"/>">>,new_li_1()),
   ?_assertEqual(<<"<li class=\"t_li wfid_tempID listitem\"/>">>,new_li_2()),
   ?_assertEqual(<<"<li class=\"t_li wfid_tempID listitem\" style=\"color: cyan;\">http://an_li.com/sample/li.jpg</li>">>,new_li_3()),
   ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,body,text,html_encode],
	 element_li:reflect())
  ].
