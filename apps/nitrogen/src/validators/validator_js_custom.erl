% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (validator_js_custom).
-include_lib ("wf.hrl").
-export([render_action/1]).

-spec render_action(#js_custom{}) -> iodata().
render_action(Record) -> 
    Text = wf:js_escape(Record#js_custom.text),
    Function = Record#js_custom.function,
    Args = Record#js_custom.args,
    wf:f("v.add(Validate.Custom, { against: ~s, args: ~s, failureMessage: \"~s\" });", [Function, Args, Text]).
