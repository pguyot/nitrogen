% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (validator_is_integer).
-include_lib ("wf.hrl").
-export([render_action/1]).

-ifdef(TEST).
-export([validate/2]).
-endif.

-spec render_action(#is_integer{}) -> iodata().
render_action(Record) -> 
    Text = wf:js_escape(Record#is_integer.text),
    validator_custom:render_action(#custom { function=fun validate/2, text = Text, tag=Record }),
    wf:f("v.add(Validate.Numericality, { notAnIntegerMessage: \"~s\", onlyInteger: true });", [Text]).

validate(_, Value) -> 
    try is_integer(list_to_integer(Value)) == true
    catch _ : _ -> false
    end.
