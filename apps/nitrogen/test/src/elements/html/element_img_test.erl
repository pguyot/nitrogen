-module(element_img_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_img_1() ->
  Rec_img = #img{},
  render_test_helper:render_element(Rec_img).

new_img_2() ->
  Rec_img = #img{class="t_img"},
  render_test_helper:render_element(Rec_img).

new_img_3() ->
  Rec_img = #img{class="t_img", style="color: cyan;", src="http://an_img.com/sample/img.jpg"},
  render_test_helper:render_element(Rec_img).

new_img_4() ->
  Rec_img = #img{class="t_img", style="color: cyan;", src="http://an_img.com/sample/img.jpg", width=80, height=60},
  render_test_helper:render_element(Rec_img).

basic_test_() ->
  [?_assertEqual(<<"<img class=\"wfid_tempID image\"/>">>,new_img_1()),
   ?_assertEqual(<<"<img class=\"t_img wfid_tempID image\"/>">>,new_img_2()),
   ?_assertEqual(<<"<img class=\"t_img wfid_tempID image\" style=\"color: cyan;\" src=\"http://an_img.com/sample/img.jpg\"/>">>,new_img_3()),
   ?_assertEqual(<<"<img class=\"t_img wfid_tempID image\" style=\"color: cyan;\" src=\"http://an_img.com/sample/img.jpg\" height=\"60\" width=\"80\"/>">>,new_img_4()),
   ?_assertEqual([is_element,module,id,anchor,actions,show_if,class,style,title,attrs,src,alt,width,height],
	 element_img:reflect())
  ].
