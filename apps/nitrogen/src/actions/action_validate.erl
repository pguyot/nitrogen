% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_validate).
-include_lib ("wf.hrl").
-compile(export_all).

-spec render_action(#validate{}) -> wf_render_action_data().
render_action(Record) -> 
    % Some values...
    TriggerPath = Record#validate.trigger,
    TargetPath = Record#validate.target,
    ValidationGroup = case Record#validate.group of
        undefined -> TriggerPath;
        Other -> Other
    end,
    ValidMessage = wf:js_escape(Record#validate.success_text),
    OnlyOnBlur = (Record#validate.on == blur),
    OnlyOnSubmit = (Record#validate.on == submit),	
    InsertAfterNode = case Record#validate.attach_to of
        undefined -> "";
        Node -> wf:f(", insertAfterWhatNode : obj(\"~s\")", [Node])
    end,

    % Create the validator Javascript...
    % 
    % TODO: using jQuery.data instead setting the validator object as property 
    % of the DOM node. We could get a problem with Internet Explorer and memory leaks.
    ConstructorJS = wf:f("var v = obj('~s').validator = new LiveValidation(obj('~s'), { validMessage: \"~s\", onlyOnBlur: ~s, onlyOnSubmit: ~s ~s});", [TargetPath, TargetPath, wf:js_escape(ValidMessage), OnlyOnBlur, OnlyOnSubmit, InsertAfterNode]),
    TriggerJS = wf:f("v.group = '~s';", [ValidationGroup]),

    % Update all child validators with TriggerPath and TargetPath...
    F = fun(X) ->
        Base = wf_utils:get_validatorbase(X),
        Base1 = Base#validatorbase { trigger = TriggerPath, target = TargetPath },
        wf_utils:replace_with_base(Base1, X)
    end,
    Validators = lists:flatten([Record#validate.validators]),
    Validators1 = [F(X) || X <- Validators],

    % Use #script element to create the final javascript to send to the browser...
    [
        ConstructorJS, TriggerJS, Validators1
    ].	
