% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_script).
-include ("wf.inc").
-compile(export_all).

-spec(render_action/3::(wf_triggerpath(), wf_targetpath(), #script{}) -> iodata()).
render_action(_TriggerPath, _TargetPath, Record) -> 
	[wf:me_var(), Record#script.script, ";"].