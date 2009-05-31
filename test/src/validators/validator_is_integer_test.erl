-module (validator_is_integer_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_validator_1() ->
    Rec = #is_integer{text="footext"},
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    lists:flatten(validator_is_integer:render_validator(TriggerPath,TargetPath,Rec)).

basic_test_() ->
    [
     ?_assertEqual("v.add(Validate.Numericality, "
		   "{ notAnIntegerMessage: \"footext\", onlyInteger: true });", 
		   new_validator_1()),
     ?_assertEqual(false, validator_is_integer:validate(no_value, "")),
     ?_assertEqual(true,  validator_is_integer:validate(no_value, "9999999999999999999999999")),
     ?_assertEqual(true,  validator_is_integer:validate(no_value, "32"))
    ].
