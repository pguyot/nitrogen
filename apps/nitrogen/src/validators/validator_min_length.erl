% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (validator_min_length).
-include_lib ("wf.hrl").
-export([render_action/1]).

-ifdef(TEST).
-export([validate/2]).
-endif.

-spec render_action(#min_length{}) -> iodata().
render_action(Record)  ->
    TriggerPath= Record#min_length.trigger,
    TargetPath = Record#min_length.target,
    Text = wf:js_escape(Record#min_length.text),
    Length = Record#min_length.length,
    validator_custom:render_action(#custom { trigger=TriggerPath, target=TargetPath, function=fun validate/2, text = Text, tag=Record }),
    wf:f("v.add(Validate.Length, { minimum: ~p, tooShortMessage: \"~s\" });", [Length, Text]).

validate(Record, Value) ->
    Record#min_length.length =< length(Value).
