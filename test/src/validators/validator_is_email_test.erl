-module (validator_is_email_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

trick_wf_state() ->
    %% render_validator will fail without this
    wf_state:clear_state(),
    wf_state:state(validators,[]).

simple_email() ->
    "bill@jones.com".

bad_email() ->
    "no_wayATshouldThisWorkDotCom".

new_validator_1() ->
    Rec = #is_email{text=simple_email()},
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    trick_wf_state(),
    lists:flatten(validator_is_email:render_validator(TriggerPath,TargetPath,Rec)).

basic_test_() ->
    [
     ?_assertEqual("v.add(Validate.Email, { failureMessage: \"bill@jones.com\" });",
		   new_validator_1()),
     ?_assertEqual(true, validator_is_email:validate(nil, "simple@email.com")),
     ?_assertEqual(true, validator_is_email:validate(nil, "a_strange+dog@your.fun.email.com")),
     ?_assertEqual(true,
		   validator_is_email:validate(nil,simple_email())),
     ?_assertEqual(false,
		   validator_is_email:validate(nil,bad_email)),
     ?_assertEqual(false,
		   validator_is_email:validate(nil,""))
    ].
