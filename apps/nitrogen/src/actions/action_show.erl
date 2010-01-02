% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_show).
-include_lib ("wf.hrl").
-compile(export_all).

-spec render_action(#show{}) -> wf_render_action_data().
render_action(Record) ->
    #jquery_effect {
        type=show,
        effect = Record#show.effect,
        options = Record#show.options,
        speed = Record#show.speed
    }.
