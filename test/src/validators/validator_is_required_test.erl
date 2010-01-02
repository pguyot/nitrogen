-module (validator_is_required_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_validator_1() ->
    wf:clear_state(),
    Rec = #is_required{text="footext"},
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    lists:flatten(validator_is_required:render_validator(TriggerPath,TargetPath,Rec)).

new_validator_with_module() ->
    wf:clear_state(),
    Rec = #is_required{text="footext", module="a_module"},
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    lists:flatten(validator_is_required:render_validator(TriggerPath,TargetPath,Rec)).

basic_test_() ->
    [
     ?_assertEqual("v.add(Validate.Presence, { failureMessage: \"footext\" });", 
		   new_validator_1()),
     ?_assertEqual("v.add(Validate.Presence, { failureMessage: \"footext\" });", 
		   new_validator_with_module()),
     ?_assertEqual(true, validator_is_required:validate(no_value, 32)),
     ?_assertEqual(false, validator_is_required:validate(no_value, []))
    ].
