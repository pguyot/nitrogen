-module (action_confirm_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_confirm_1() ->
  Record = #confirm { text="Do you want to continue?", postback=continue },
  TriggerPath = "trigger_path",
  TargetPath = "target_path",
  lists:flatten(action_confirm:render_action(TriggerPath, TargetPath, Record)).


basic_test_() ->
  [?_assertEqual("wf_current_path=''; $(obj('target_path')).fadeIn(\"a_speed\");",
                 new_confirm_1())
  ].
