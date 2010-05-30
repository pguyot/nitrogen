-module(element_label_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_label_1() ->
    Rec_label = #label{},
    render_test_helper:render_element(Rec_label).

new_label_2() ->
    Rec_label = #label{class="t_label"},
    render_test_helper:render_element(Rec_label).

new_label_3() ->
    Rec_label = #label{class="t_label", style="color: cyan;", text="Username:"},
    render_test_helper:render_element(Rec_label).

basic_test_() ->
    [?_assertEqual(<<"<label class=\"wfid_tempID label\"></label>">>,new_label_1()),
     ?_assertEqual(<<"<label class=\"t_label wfid_tempID label\"></label>">>,new_label_2()),
     ?_assertEqual(<<"<label class=\"t_label wfid_tempID label\" style=\"color: cyan;\">Username:</label>">>,new_label_3()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,text,html_encode],
           element_label:reflect())
    ].
