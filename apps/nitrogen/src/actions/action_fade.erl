% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_fade).
-include_lib ("wf.hrl").
-compile(export_all).

-spec render_action(#fade{}) -> wf_render_action_data().
render_action(Record) ->
    #jquery_effect {
        type=fade,
        speed = Record#fade.speed
    }.
