-module (validator_is_required_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_validator_1() ->
    Rec = #is_required{text="footext"},
    render_test_helper:render_action(Rec).

basic_test_() ->
    [
     ?_assertEqual(<<"obj('.wfid_anchor').validator.add(Validate.Presence, { failureMessage: \"footext\" });">>, 
		   new_validator_1()),
     ?_assertEqual(true, validator_is_required:validate(no_value, 32)),
     ?_assertEqual(false, validator_is_required:validate(no_value, []))
    ].
