-module (validator_confirm_password_test).
-export([new_validator_1/0, new_validator_with_module/0]).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

trick_wf_state() ->
    %% render_validator will fail without this
    wf_state:clear_state(),
    wf_state:state(validators,[]).

new_validator_1() ->
    Rec = #confirm_password{text="Do you want to continue?", password="password"},
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    trick_wf_state(),
    lists:flatten(validator_confirm_password:render_validator(TriggerPath,TargetPath,Rec)).

new_validator_with_module() ->
    Rec = #confirm_password{text="Do you want to continue", 
			    module="a_module", password="password"},
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    trick_wf_state(),
    lists:flatten(validator_confirm_password:render_validator(TriggerPath,TargetPath,Rec)).

new_validator_3() ->
    %% password refers the the field name- not the password value
    %% you get a badmatch if it isnt in the paths
    Rec = #confirm_password{text="footext", password="passwordTextBox"},
    trick_wf_state(),
    Paths= [{["passwordTextBox","page"],"thepassword"}],
    put(request_query_paths, Paths),
    TestValue = "thepassword",
    validator_confirm_password:validate(Rec, TestValue).

get_result(M,F) ->
    mock_app ! {mf, M,F, self()},
    receive
	{mf, M,F, Response} ->
	    io:format("validator MF received ~p~n",[Response]),
	    Response;
	Other -> {error, Other}
    end.

get_result(M,F,A) ->
    %% io:format("mock_app registered = ~p~n",[lists:member(mock_app,registered())]),
    mock_app ! {mfa, M,F,A, self()},
    receive
	{mfa, M,F,A, Response} ->
	    io:format("validator MFA received ~p~n",[Response]),
	    Response;
	Other -> {error, Other}
    end.

test_1() ->
    Result = get_result(?MODULE,new_validator_1),
    eunit_helper:regexpMatch("Do you want to continue", Result).

test_2() ->
    eunit_helper:regexpMatch("Do you want to continue", get_result(?MODULE,new_validator_with_module)).


basic_test_() ->
    {setup,
    fun() ->
        ok = application:start(mock_app_inets)
    end,
    fun(_) ->
        ok = application:stop(mock_app_inets)
    end,
    [
     ?_assertEqual(true, test_1()),
     ?_assertEqual(true, test_2()),
     ?_assertEqual(true, new_validator_3())
    ]}.
