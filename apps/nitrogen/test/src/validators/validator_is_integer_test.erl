-module (validator_is_integer_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_validator_1() ->
    Rec = #is_integer{text="footext"},
    render_test_helper:render_action(Rec).

basic_test_() ->
    [
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');v.add(Validate.Numericality, "
		   "{ notAnIntegerMessage: \"footext\", onlyInteger: true });">>,
		   new_validator_1()),
     ?_assertEqual(false, validator_is_integer:validate(no_value, "")),
     ?_assertEqual(true,  validator_is_integer:validate(no_value, "9999999999999999999999999")),
     ?_assertEqual(true,  validator_is_integer:validate(no_value, "32"))
    ].
