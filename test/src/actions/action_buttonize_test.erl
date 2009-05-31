-module (action_buttonize_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

new_buttonize_1() ->
    Record = #buttonize{},
    TriggerPath = "trigger_path",
    TargetPath = "target_path",
    lists:flatten(action_buttonize:render_action(TriggerPath, TargetPath, Record)).

basic_test_() ->
    [?_assertEqual("Nitrogen.$observe_event(obj('trigger_path'), 'mouseover', function anonymous(event) {  Nitrogen.$current_id='';Nitrogen.$current_path='target_path';jQuery(obj('target_path')).addClass('hover', 0); });\r\nNitrogen.$observe_event(obj('trigger_path'), 'mouseout', function anonymous(event) {  Nitrogen.$current_id='';Nitrogen.$current_path='target_path';jQuery(obj('target_path')).removeClass('hover', 0); });\r\nNitrogen.$observe_event(obj('trigger_path'), 'mousedown', function anonymous(event) {  Nitrogen.$current_id='';Nitrogen.$current_path='target_path';jQuery(obj('target_path')).addClass('clicked', 0); });\r\nNitrogen.$observe_event(obj('trigger_path'), 'mouseup', function anonymous(event) {  Nitrogen.$current_id='';Nitrogen.$current_path='target_path';jQuery(obj('target_path')).removeClass('clicked', 0); });\r\n",
		   new_buttonize_1())
    ].
