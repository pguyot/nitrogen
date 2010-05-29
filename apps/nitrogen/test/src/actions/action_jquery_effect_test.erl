-module (action_jquery_effect_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_jquery_effect_1(EffectName) ->
    %% use of quote and double quote on key/value pairs is deliberate
    Record = #jquery_effect{ type=EffectName, effect=none, speed="a_speed", options=[{"Key1","Value1"},{'Key2','Value2'}], class="a_class", easing="some_easing"},
    render_test_helper:render_action(Record).

new_jquery_effect_2(EffectName) ->
    %% The effect  in a jquery_effect is a jquery_ui effect name
    Record = #jquery_effect{ type=EffectName, effect="Pulsate", speed="a_speed", options=[{"Key1","Value1"},{'Key2','Value2'}], class="a_class", easing="some_easing"},
    render_test_helper:render_action(Record).

basic_test_() ->
    [
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').show();">>,
		   new_jquery_effect_1('show')),
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').show('Pulsate', { Key1: 'Value1',Key2: 'Value2' }, \"a_speed\");">>,
		   new_jquery_effect_2('show')),  % With an Effect
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').hide();">>,
		   new_jquery_effect_1('hide')),
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').hide('Pulsate', { Key1: 'Value1',Key2: 'Value2' }, \"a_speed\");">>,
		   new_jquery_effect_2('hide')),  % With an Effect
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').fadeIn(\"a_speed\");">>,
		   new_jquery_effect_1('appear')),
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').fadeOut(\"a_speed\");">>,
		   new_jquery_effect_1('fade')),
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').effect('none', { Key1: 'Value1',Key2: 'Value2' }, \"a_speed\");">>,
		   new_jquery_effect_1('effect')),
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').toggle();">>,
		   new_jquery_effect_1('toggle')),
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').addClass('a_class', \"a_speed\");">>,
		   new_jquery_effect_1('add_class')),
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').removeClass('a_class', \"a_speed\");">>,
		   new_jquery_effect_1('remove_class')),
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').animate({ Key1: 'Value1',Key2: 'Value2' }, \"a_speed\", 'some_easing');">>, new_jquery_effect_1('animate'))
    ].

to_js_test_() ->
    [
     ?_assertEqual("{ alist: 'backgroundblue' }", action_jquery_effect:options_to_js([{alist,["background","blue"]}])),
     ?_assertEqual("{ akey: 'WHAT IS THIS SUPPOSED BE?' }", action_jquery_effect:options_to_js([{akey,"WHAT IS THIS SUPPOSED BE?"}])),
     ?_assertEqual("{ akey: true }", action_jquery_effect:options_to_js([{akey,true}])),
     ?_assertEqual("{ akey: false }", action_jquery_effect:options_to_js([{akey,false}])),
     ?_assertEqual("{ akey: 'anatom' }", action_jquery_effect:options_to_js([{akey,'anatom'}])),
     ?_assertEqual("{ akey: 'something else' }", action_jquery_effect:options_to_js([{akey,["something else"]}])),
     ?_assertEqual("{ akey: 152 }", action_jquery_effect:options_to_js([{akey,152}]))
    ].
