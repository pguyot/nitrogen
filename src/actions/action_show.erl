% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_show).
-include ("wf.inc").
-compile(export_all).

-spec(render_action/3::(wf_triggerpath(), wf_targetpath(), #show{}) -> iodata()).
render_action(TriggerPath, TargetPath, Record) ->
	Effect = #jquery_effect {
		type=show,
		effect = Record#show.effect,
		options = Record#show.options,
		speed = Record#show.speed
	},
	action_jquery_effect:render_action(TriggerPath, TargetPath, Effect).