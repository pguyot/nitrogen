-module(element_ul_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_ul_1() ->
  Rec_ul = #ul{},
  render_test_helper:render_element(Rec_ul).

new_ul_2() ->
  Rec_ul = #ul{class="t_ul"},
  render_test_helper:render_element(Rec_ul).

new_ul_3() ->
  Rec_ul = #ul{class="t_ul", style="color: cyan;", body="SOME BODY"},
  render_test_helper:render_element(Rec_ul).

new_ul_4() ->
  Rec_ul = #ul{class="t_ul", style="color: cyan;", body=[#li{body="li_1"}, #li{body="li_2"}]},
  render_test_helper:render_element(Rec_ul).

basic_test_() ->
  [
   ?_assertEqual(<<"<ul class=\"wfid_tempID list\"/>">>,new_ul_1()),
   ?_assertEqual(<<"<ul class=\"t_ul wfid_tempID list\"/>">>,new_ul_2()),
   ?_assertEqual(<<"<ul class=\"t_ul wfid_tempID list\" style=\"color: cyan;\">SOME BODY</ul>">>,new_ul_3()),
   ?_assertEqual(<<"<ul class=\"t_ul wfid_tempID list\" style=\"color: cyan;\"><li class=\"wfid_tempID listitem\">li_1</li><li class=\"wfid_tempID listitem\">li_2</li></ul>">>,new_ul_4()),
   ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,body],
	 element_ul:reflect())
  ].
