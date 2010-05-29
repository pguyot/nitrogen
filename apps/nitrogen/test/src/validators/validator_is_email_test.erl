-module (validator_is_email_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

simple_email() ->
    "bill@jones.com".

bad_email() ->
    "no_wayATshouldThisWorkDotCom".

new_validator_1() ->
    Rec = #is_email{text=simple_email()},
    render_test_helper:render_action(Rec).

basic_test_() ->
    [
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');v.add(Validate.Email, { failureMessage: \"bill@jones.com\" });">>,
		   new_validator_1()),
     ?_assertEqual(true, validator_is_email:validate(nil, "simple@email.com")),
     ?_assertEqual(true, validator_is_email:validate(nil, "a_strange+dog@your.fun.email.com")),
     ?_assertEqual(true,
		   validator_is_email:validate(nil,simple_email())),
     ?_assertEqual(false,
		   validator_is_email:validate(nil,bad_email())),
     ?_assertEqual(false,
		   validator_is_email:validate(nil,""))
    ].
