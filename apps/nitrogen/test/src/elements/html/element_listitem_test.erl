-module(element_listitem_test).
-author("michael@mullistitemechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_listitem_1() ->
    Rec_listitem = #listitem{},
    render_test_helper:render_element(Rec_listitem).

new_listitem_2() ->
    Rec_listitem = #listitem{class="t_listitem"},
    render_test_helper:render_element(Rec_listitem).

new_listitem_3() ->
    Rec_listitem = #listitem{class="t_listitem", style="color: cyan;", text="http://an_listitem.com/sample/listitem.jpg"},
    render_test_helper:render_element(Rec_listitem).

basic_test_() ->
    [?_assertEqual(<<"<li class=\"wfid_tempID listitem\"/>">>,new_listitem_1()),
     ?_assertEqual(<<"<li class=\"t_listitem wfid_tempID listitem\"/>">>,new_listitem_2()),
     ?_assertEqual(<<"<li class=\"t_listitem wfid_tempID listitem\" style=\"color: cyan;\">http://an_listitem.com/sample/listitem.jpg</li>">>,new_listitem_3()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,body,text,html_encode],
	       element_listitem:reflect())
    ].
