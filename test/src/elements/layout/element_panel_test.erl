-module(element_panel_test).
-compile([export_all]).
-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_panel_1() ->
  Rec_panel = #panel{},
  lists:flatten(element_panel:render("1",Rec_panel)).

new_panel_2() ->
  Rec_panel = #panel{class="t_div"},
  lists:flatten(element_panel:render("2",Rec_panel)).

new_panel_3() ->
  Rec_panel = #panel{class="t_div", style="color: cyan;", body=[#h1{text="H1"}]},
  lists:flatten(element_panel:render("3",Rec_panel)).

new_panel_4() ->
  Rec_panel = #panel{class="t_div", style="color: cyan;", body=[#h1{text="H1"}], title="panel_tooltip"},
  lists:flatten(element_panel:render("4",Rec_panel)).

new_panel_5() ->
  Rec_panel = #panel{class="t_div", style="color: cyan;", body=[#h1{text="Hello"}], title="panel_tooltip", attrs=[{lang, "en"}]},
  lists:flatten(element_panel:render("5",Rec_panel)).

basic_test_() ->
  [?_assertEqual("<div id=\"1\" class=\"panel\"></div>",new_panel_1()),
   ?_assertEqual("<div id=\"2\" class=\"panel t_div\"></div>",new_panel_2()),
   ?_assert(eunit_helper:regexpMatch("<div id=\"3\" class=\"panel t_div\" style=\"color: cyan;\"><h1 id=\".*?\" class=\"h1\">H1</h1></div>", new_panel_3())),
   ?_assert(eunit_helper:regexpMatch("<div id=\"4\" class=\"panel t_div\" style=\"color: cyan;\" title=\"panel_tooltip\"><h1 id=\".*?\" class=\"h1\">H1</h1></div>", new_panel_4())),
   ?_assert(eunit_helper:regexpMatch("<div id=\"5\" class=\"panel t_div\" style=\"color: cyan;\" title=\"panel_tooltip\" lang=\"en\"><h1 id=\".*?\" class=\"h1\">Hello</h1></div>", new_panel_5())),
   ?_assertEqual([module,id,actions,show_if,class,style,title,attrs,body],
	 element_panel:reflect())
  ].
