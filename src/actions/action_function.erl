% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_function).
-include ("wf.inc").
-compile(export_all).

% This action is used internally by Nitrogen.
render_action(Record) ->
    F = Record#function.function,
    F().