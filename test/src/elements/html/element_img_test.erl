-module(element_img_test).
-compile([export_all]).

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_img_1() ->
  Rec_img = #img{},
  lists:flatten(element_img:render("1",Rec_img)).

new_img_2() ->
  Rec_img = #img{class="t_img"},
  lists:flatten(element_img:render("2",Rec_img)).

new_img_3() ->
  Rec_img = #img{class="t_img", style="color: cyan;", src="http://an_img.com/sample/img.jpg"},
  lists:flatten(element_img:render("3",Rec_img)).

new_img_4() ->
  Rec_img = #img{class="t_img", style="color: cyan;", src="http://an_img.com/sample/img.jpg", width=80, height=60},
  lists:flatten(element_img:render("4",Rec_img)).

basic_test_() ->
  [?_assertEqual("<img id=\"1\" class=\"image\"/>",new_img_1()),
   ?_assertEqual("<img id=\"2\" class=\"image t_img\"/>",new_img_2()),
   ?_assertEqual("<img id=\"3\" class=\"image t_img\" style=\"color: cyan;\" src=\"http://an_img.com/sample/img.jpg\"/>",new_img_3()),
   ?_assertEqual("<img id=\"4\" class=\"image t_img\" style=\"color: cyan;\" src=\"http://an_img.com/sample/img.jpg\" height=\"60\" width=\"80\"/>",new_img_4()),
   ?_assertEqual([module,id,actions,show_if,class,style,title,attrs,src,alt,width,height],
	 element_img:reflect())
  ].
