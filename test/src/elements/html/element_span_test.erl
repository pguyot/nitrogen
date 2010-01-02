-module(element_span_test).
-compile([export_all]).

-author("michael@mulpechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_span_1() ->
    Rec_span = #span{},
    lists:flatten(element_span:render("1",Rec_span)).

new_span_2() ->
    Rec_span = #span{class="t_span"},
    lists:flatten(element_span:render("2",Rec_span)).

new_span_3() ->
    Rec_span = #span{class="t_span", style="color: cyan;", text="Some Text"},
    lists:flatten(element_span:render("3",Rec_span)).

new_span_4() ->
  Rec_span = #span{class="t_span", text="Hello world!", html_encode=false, attrs=[{lang, "en"}]},
  lists:flatten(element_span:render("4",Rec_span)).

new_span_5() ->
  Rec_span = #span{class="t_span", body=[#link{text="English", url="/", attrs=[{lang, "en"}]}]},
  lists:flatten(element_span:render("5",Rec_span)).

basic_test_() ->
    [?_assertEqual("<span id=\"1\"/>",new_span_1()),
     ?_assertEqual("<span id=\"2\" class=\"t_span\"/>",new_span_2()),
     ?_assertEqual("<span id=\"3\" class=\"t_span\" style=\"color: cyan;\">Some&nbsp;Text</span>", new_span_3()),
     ?_assertEqual("<span id=\"4\" class=\"t_span\" lang=\"en\">Hello world!</span>", new_span_4()),
     ?_assert(eunit_helper:regexpMatch("<span id=\"5\" class=\"t_span\"><a id=\".*?\" href=\"/\" class=\"link\" lang=\"en\">English</a></span>", new_span_5())),
     ?_assertEqual([module,id,actions,show_if,class,style,title,attrs,text,body,html_encode],
           element_span:reflect())
    ].
