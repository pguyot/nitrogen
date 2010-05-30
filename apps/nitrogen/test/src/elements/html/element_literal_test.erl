-module(element_literal_test).
-author("michael@mulpechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_literal_1() ->
    Rec_literal = #literal{},
    render_test_helper:render_element(Rec_literal).

new_literal_2() ->
    Rec_literal = #literal{class="t_literal"},
    render_test_helper:render_element(Rec_literal).

new_literal_3() ->
    Rec_literal = #literal{class="t_literal", style="color: cyan;", text="http://an_literal.com/sample/literal.jpg"},
    render_test_helper:render_element(Rec_literal).

basic_test_() ->
    [?_assertEqual(<<>>,new_literal_1()),
     ?_assertEqual(<<>>,new_literal_2()),
     ?_assertEqual(<<"http://an_literal.com/sample/literal.jpg">>,new_literal_3()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,text,html_encode],
           element_literal:reflect())
    ].
