-module(element_ol_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_ol_1() ->
  Rec_ol = #ol{},
  render_test_helper:render_element(Rec_ol).

new_ol_2() ->
  Rec_ol = #ol{class="t_ol"},
  render_test_helper:render_element(Rec_ol).

new_ol_3() ->
  Rec_ol = #ol{class="t_ol", style="color: cyan;", body="SOME BODY"},
  render_test_helper:render_element(Rec_ol).

basic_test_() ->
  [
   ?_assertEqual(<<"<ol class=\"wfid_tempID list\"/>">>,new_ol_1()),
   ?_assertEqual(<<"<ol class=\"t_ol wfid_tempID list\"/>">>,new_ol_2()),
   ?_assertEqual(<<"<ol class=\"t_ol wfid_tempID list\" style=\"color: cyan;\">SOME BODY</ol>">>,new_ol_3()),
   ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,body],
	 element_ol:reflect())
  ].
