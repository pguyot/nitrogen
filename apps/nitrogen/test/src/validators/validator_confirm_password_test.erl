-module (validator_confirm_password_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_validator_1() ->
    Rec = #confirm_password{text="Do you want to continue?", password="password"},
    render_test_helper:render_action(Rec).

new_validator_2() ->
    %% password refers the the field name- not the password value
    %% you get a badmatch if it isnt in the paths
    Rec = #confirm_password{text="footext", password="passwordTextBox"},
    Paths= [{["passwordTextBox","page"],"thepassword"}],
    wf_handler:set_handler(default_query_handler, []),
    wf_handler:update_handler_state(query_handler, Paths),
    TestValue = "thepassword",
    validator_confirm_password:validate(Rec, TestValue).

basic_test_() ->
    [
     ?_assertEqual(<<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');v.add(Validate.Custom, { against: function(value, args) { return (value == obj('password').value); }, args: {}, failureMessage: \"Do you want to continue?\" });">>, new_validator_1()),
     ?_assertEqual(true, new_validator_2())
    ].
