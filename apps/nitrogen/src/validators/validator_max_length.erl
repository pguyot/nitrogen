% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% Contributions from Torbjorn Tornkvist (tobbe@tornkvist.org)
% See MIT-LICENSE for licensing information.

-module (validator_max_length).
-include_lib ("wf.hrl").
-export([render_action/1]).

-spec render_action(#max_length{}) -> iodata().
render_action(Record)  ->
    Text = wf:js_escape(Record#max_length.text),
    Length = Record#max_length.length,
    validator_custom:render_action(#custom { function=fun validate/2, text = Text, tag=Record }),
    wf:f("v.add(Validate.Length, { maximum: ~p, tooLongMessage: \"~s\" });", [Length, Text]).

validate(Record, Value) ->
    Record#max_length.length >= length(Value).
