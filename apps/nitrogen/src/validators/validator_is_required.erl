% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (validator_is_required).
-include_lib ("wf.hrl").
-export([render_action/1]).

-ifdef(TEST).
-export([validate/2]).
-endif.

-spec render_action(#is_required{}) -> wf_render_action_data().
render_action(Record) -> 
    TriggerPath = Record#is_required.trigger,
    TargetPath = Record#is_required.target,
    Text = wf:js_escape(Record#is_required.text),
    CustomValidatorAction = #custom { trigger=TriggerPath, target=TargetPath, function=fun validate/2, text=Text, tag=Record },
    Script = wf:f("obj('~s').validator.add(Validate.Presence, { failureMessage: \"~s\" });", [TargetPath, Text]),
    [CustomValidatorAction, Script].

validate(_, Value) -> 
    Value /= [].
