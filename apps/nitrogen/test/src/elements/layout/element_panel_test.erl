-module(element_panel_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_panel_1() ->
  Rec_panel = #panel{},
  render_test_helper:render_element(Rec_panel).

new_panel_2() ->
  Rec_panel = #panel{class="t_div"},
  render_test_helper:render_element(Rec_panel).

new_panel_3() ->
  Rec_panel = #panel{class="t_div", style="color: cyan;", body=[#h1{text="H1"}]},
  render_test_helper:render_element(Rec_panel).

new_panel_4() ->
  Rec_panel = #panel{class="t_div", style="color: cyan;", body=[#h1{text="H1"}], title="panel_tooltip"},
  render_test_helper:render_element(Rec_panel).

new_panel_5() ->
  Rec_panel = #panel{class="t_div", style="color: cyan;", body=[#h1{text="Hello"}], title="panel_tooltip", attrs=[{lang, "en"}]},
  render_test_helper:render_element(Rec_panel).

basic_test_() ->
  [?_assertEqual(<<"<div class=\"wfid_tempID panel\"></div>">>,new_panel_1()),
   ?_assertEqual(<<"<div class=\"t_div wfid_tempID panel\"></div>">>,new_panel_2()),
   ?_assertEqual(<<"<div class=\"t_div wfid_tempID panel\" style=\"color: cyan;\"><h1 class=\"wfid_tempID h1\">H1</h1></div>">>, new_panel_3()),
   ?_assertEqual(<<"<div class=\"t_div wfid_tempID panel\" style=\"color: cyan;\" title=\"panel_tooltip\"><h1 class=\"wfid_tempID h1\">H1</h1></div>">>, new_panel_4()),
   ?_assertEqual(<<"<div class=\"t_div wfid_tempID panel\" style=\"color: cyan;\" title=\"panel_tooltip\" lang=\"en\"><h1 class=\"wfid_tempID h1\">Hello</h1></div>">>, new_panel_5()),
   ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,body],
	 element_panel:reflect())
  ].
