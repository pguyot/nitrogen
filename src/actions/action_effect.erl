% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_effect).
-include ("wf.inc").
-compile(export_all).

-spec(render_action/3::(wf_triggerpath(), wf_targetpath(), #effect{}) -> iodata()).
render_action(TriggerPath, TargetPath, Record) ->
	Effect = #jquery_effect {
		type=effect,
		effect = Record#effect.effect,
		options = Record#effect.options,
		speed = Record#effect.speed
	},
	action_jquery_effect:render_action(TriggerPath, TargetPath, Effect).