% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_validation_error).
-include ("wf.inc").
-compile(export_all).

-spec(render_action/3::(wf_triggerpath(), wf_targetpath(), #validation_error{}) -> iodata()).
render_action(TriggerPath, TargetPath, Record) -> 
	Text = wf_utils:js_escape(Record#validation_error.text),
	Script = [
		"var v = new LiveValidation(obj('me'), { onlyOnSubmit: true });",
		wf:f("v.add(Validate.Custom, { against: Nitrogen.$return_false, failureMessage: \"~s\" });", [Text]),
		"v.validate();"
	],
	action_script:render_action(TriggerPath, TargetPath, #script { script=Script }).
		
	
