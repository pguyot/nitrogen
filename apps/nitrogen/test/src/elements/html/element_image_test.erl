-module(element_image_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_image_1() ->
    Rec_image = #image{},
    render_test_helper:render_element(Rec_image).

new_image_2() ->
    Rec_image = #image{class="t_image"},
    render_test_helper:render_element(Rec_image).

new_image_3() ->
    Rec_image = #image{class="t_image", style="color: cyan;", image="http://an_image.com/sample/image.jpg"},
    render_test_helper:render_element(Rec_image).

basic_test_() ->
  [?_assertEqual(<<"<img class=\"wfid_tempID image\"/>">>,new_image_1()),
   ?_assertEqual(<<"<img class=\"t_image wfid_tempID image\"/>">>,new_image_2()),
   ?_assertEqual(<<"<img class=\"t_image wfid_tempID image\" style=\"color: cyan;\" src=\"http://an_image.com/sample/image.jpg\"/>">>,new_image_3()),
     ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,image,alt],
           element_image:reflect())
    ].
