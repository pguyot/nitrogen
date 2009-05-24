-module (action_appear_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_appear_1() ->
  Record = #appear{speed="a_speed"},
  TriggerPath = "trigger_path",
  TargetPath = "target_path",
  lists:flatten(action_appear:render_action(TriggerPath, TargetPath, Record)).

basic_test_() ->
  [?_assertEqual("Nitrogen.$current_id='';Nitrogen.$current_path='';jQuery(obj('target_path')).fadeIn(\"a_speed\");",
                 new_appear_1())
  ].
