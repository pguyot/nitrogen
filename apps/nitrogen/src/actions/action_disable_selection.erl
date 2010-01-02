% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_disable_selection).
-include_lib ("wf.hrl").
-compile(export_all).

-spec render_action(#disable_selection{}) -> wf_render_action_data().
render_action(_Record) -> 
    "Nitrogen.$disable_selection(obj(me));".
