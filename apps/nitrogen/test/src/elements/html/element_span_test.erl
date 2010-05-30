-module(element_span_test).
-author("michael@mulpechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_span_1() ->
    Rec_span = #span{},
    render_test_helper:render_element(Rec_span).

new_span_2() ->
    Rec_span = #span{class="t_span"},
    render_test_helper:render_element(Rec_span).

new_span_3() ->
    Rec_span = #span{class="t_span", style="color: cyan;", text="Some Text"},
    render_test_helper:render_element(Rec_span).

new_span_4() ->
  Rec_span = #span{class="t_span", text="Hello world!", html_encode=false, attrs=[{lang, "en"}]},
  render_test_helper:render_element(Rec_span).

new_span_5() ->
  Rec_span = #span{class="t_span", body=[#link{text="English", url="/", attrs=[{lang, "en"}]}]},
  render_test_helper:render_element(Rec_span).

new_span_6() ->
  Rec_span = #span{class="t_span", text="Who's who"},
  render_test_helper:render_element(Rec_span).

basic_test_() ->
    [?_assertEqual(<<"<span class=\"wfid_tempID\"></span>">>,new_span_1()),
     ?_assertEqual(<<"<span class=\"t_span wfid_tempID\"></span>">>,new_span_2()),
     ?_assertEqual(<<"<span class=\"t_span wfid_tempID\" style=\"color: cyan;\">Some Text</span>">>, new_span_3()),
     ?_assertEqual(<<"<span class=\"t_span wfid_tempID\" lang=\"en\">Hello world!</span>">>, new_span_4()),
     ?_assertEqual(<<"<span class=\"t_span wfid_tempID\"><a href=\"/\" class=\"wfid_tempID link\" lang=\"en\">English</a></span>">>, new_span_5()),
     ?_assertEqual(<<"<span class=\"t_span wfid_tempID\">Who&#39;s who</span>">>, new_span_6()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,text,body,html_encode],
           element_span:reflect())
    ].
