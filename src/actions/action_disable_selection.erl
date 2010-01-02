% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_disable_selection).
-include ("wf.inc").
-compile(export_all).

-spec(render_action/3::(wf_triggerpath(), wf_targetpath(), #disable_selection{}) -> iodata()).
render_action(_TriggerPath, TargetPath, _Record) -> 
	[
		wf:me_var(), 
		wf:f("Nitrogen.$disable_selection(obj('~s'));", [wf:to_js_id(TargetPath)])	
	].