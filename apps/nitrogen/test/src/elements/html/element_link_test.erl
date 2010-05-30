-module(element_link_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_link_1() ->
    Rec_link = #link{},
    render_test_helper:render_element(Rec_link).

new_link_2() ->
    Rec_link = #link{postback="undefined"},
    render_test_helper:render_element(Rec_link).

new_link_3() ->
    Rec_link = #link{postback="Postback"},
    render_test_helper:render_element(Rec_link).

new_link_4() ->
    Rec_link = #link{body=#image { image="/path/to/image.gif" }},
    render_test_helper:render_element(Rec_link).

new_link_5() ->
    Rec_link = #link{body="A LINK BODY", text="LINK TEXT", html_encode=true, url="not_javascript", postback="mypostback"},
    render_test_helper:render_element(Rec_link).

basic_test_() ->
    [?_assertEqual(<<"<a href=\"javascript:\" class=\"wfid_tempID link\"/>">>, new_link_1()),
     ?_assertEqual(<<"<a href=\"javascript:\" class=\"wfid_tempID link\"/>">>, new_link_2()),
     ?_assertEqual(<<"<a href=\"javascript:\" class=\"wfid_tempID link\"/>">>, new_link_3()),
     ?_assertEqual(<<"<a href=\"javascript:\" class=\"wfid_tempID link\"><img class=\"wfid_tempID image\" src=\"/path/to/image.gif\"/></a>">>,
                                     new_link_4()),
     ?_assertEqual(<<"<a href=\"not_javascript\" class=\"wfid_tempID link\">LINK TEXTA LINK BODY</a>">>, new_link_5()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,text,body, html_encode,url,postback,delegate],
           element_link:reflect())
    ].
