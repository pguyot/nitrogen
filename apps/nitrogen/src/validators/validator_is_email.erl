% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (validator_is_email).
-include_lib ("wf.hrl").
-export([render_action/1]).

-ifdef(TEST).
-export([validate/2]).
-endif.

-spec render_action(#is_email{}) -> iodata().
render_action(Record)  ->
    TriggerPath= Record#is_email.trigger,
    TargetPath = Record#is_email.target,
    Text = wf:js_escape(Record#is_email.text),
    validator_custom:render_action(#custom { 
        trigger=TriggerPath, 
        target=TargetPath, 
        function=fun validate/2, text = Text, tag=Record 
    }),
    wf:f("v.add(Validate.Email, { failureMessage: \"~s\" });", [Text]).

validate(_, Value) ->
    case re:run(wf:to_iodata(Value), "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+") of
        {match, _} -> true;
        _ -> false
    end.
