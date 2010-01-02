-ifndef(wf_inc).
-define(wf_inc, ok).

-ifndef(HAVE_BOOLEAN).
-type(boolean()            :: true | false).
-endif.
-type(wf_actions()         :: tuple() | list()).
-type(wf_easing()          :: swing | linear).
-type(wf_speed()           :: integer()).
-type(wf_options()         :: list(tuple())).
-type(wf_class()           :: iodata() | atom() | [any()]).
-type(wf_postback()        :: string()).
-type(wf_path()            :: me | atom() | string() | [atom()] | [string()]).
-type(wf_targetpath()      :: wf_path()).
-type(wf_triggerpath()     :: wf_path()).
-type(wf_id()              :: atom() | string()).

%%% CONTEXT %%%

% Page Request Information.
-record(page_context, {
	series_id,   % A unique ID assigned to the first request which stays constant on repeated requests.
	module,      % The requested page module
	path_info,   % Any extra info passed with the request
	async_mode= comet % {poll, Interval} or comet 
}).

% Event Information. A serialized version of this record
% is sent by the browser when an event is called.
-record(event_context, {
  module,     % The module that should handle the event
  tag,        % An Erlang term that is passed along with the event
  type,       % The type of event postback, comet, continuation, upload
	anchor,     % The element id to which trigger and target are relative.
	validation_group % The validation group that should be run when this event is fired.
}).

% Handlers Context-
% Handlers are used to encapsulate Nitrogen's behaviour, and
% to allow other frameworks to substitute their own behaviour.
% These are set in wf_context:make_context/1
-record(handler_context, {
	name,    % The name of a handler. See wf_context for a list.
	module,     % A module that provides the logic for a handler. This can be substituted by your app.
	config,     % The config of the handler, set at the beginning of each request.
	state       % The state of the handler, serialized and maintained between postbacks in a series.
}).

-record(context, {
	% Transient Information
	type,                % Either first_request, postback_request, or static_file
	request_bridge,      % Holds the simple_bridge request object
	response_bridge,     % Holds the simple_bridge response object
	anchor=undefined,    % Holds the unique ID of the current anchor element.
	data=[],             % Holds whatever the page_module:main/1 method returns: HTML, Elements, Binary, etc..
	queued_actions=[],   % List of actions queued in main/1, event/2, or when rendering elements.	

	% These are all serialized, sent to the browser
	% and de-serialized on each request.
	page_context,
	event_context,
	handler_list
}).

%%% LOGGING %%%
-ifndef(debug_print).
-define(debug_print, true).
-define(PRINT(Var), error_logger:info_msg("DEBUG: ~p:~p~n~p~n  ~p~n", [?MODULE, ?LINE, ??Var, Var])).
-define(LOG(Msg, Args), error_logger:info_msg(Msg, Args)).
-define(DEBUG, error_logger:info_msg("DEBUG: ~p:~p~n", [?MODULE, ?LINE])).
-endif.

%%% GUARDS %%%
-define (IS_STRING(Term), (is_list(Term) andalso Term /= [] andalso is_integer(hd(Term)))).

%%% FRAMEWORK %%%

%%% Elements %%%
%% HTML5 defines plenty of attributes, we support natively class, style and title (id is special).
%% Other attributes should be encoded in a attrs proplist.
-define(ELEMENT_BASE(Module), is_element=is_element, module=Module :: atom(), id::undefined | wf_id(), anchor, actions::undefined | wf_actions(), show_if=true ::boolean(), class=""::wf_class(), style=""::iodata(), title=""::undefined | iodata(), attrs=[]).
-record(elementbase, {?ELEMENT_BASE(undefined)}).
-record(template, {?ELEMENT_BASE(element_template), file, bindings=[] }).
-record(function_el, {?ELEMENT_BASE(element_function), function=fun() -> [] end}).
-record(body, {?ELEMENT_BASE(element_body), body=[]}).
-record(h1, {?ELEMENT_BASE(element_h1), text="", html_encode=true}).
-record(h2, {?ELEMENT_BASE(element_h2), text="", html_encode=true}).
-record(h3, {?ELEMENT_BASE(element_h3), text="", html_encode=true}).
-record(h4, {?ELEMENT_BASE(element_h4), text="", html_encode=true}).
-record(list, {?ELEMENT_BASE(element_list), numbered=false, body=[]}).
-record(listitem, {?ELEMENT_BASE(element_listitem), body=[], text="", html_encode=true}).
-record(br, {?ELEMENT_BASE(element_br) }).
-record(hr, {?ELEMENT_BASE(element_hr) }).
-record(p, {?ELEMENT_BASE(element_p), body=""}).
-record(label, {?ELEMENT_BASE(element_label), text="", html_encode=true}).
-record(value, {?ELEMENT_BASE(element_value), text="", html_encode=true}).
-record(link, {?ELEMENT_BASE(element_link), text="", body="", html_encode=true, url="javascript:", postback, delegate}).
-record(error, {?ELEMENT_BASE(element_error), text="", html_encode=true}).
-record(span, {?ELEMENT_BASE(element_span), text="", body="", html_encode=true}).
-record(button, {?ELEMENT_BASE(element_button), text="Button", html_encode=true, postback, delegate}).
-record(literal, {?ELEMENT_BASE(element_literal), text="", html_encode=true}).
-record(textbox, {?ELEMENT_BASE(element_textbox), text="", html_encode=true, next, postback, delegate}).
-record(hidden, {?ELEMENT_BASE(element_hidden), text="", html_encode=true}).
-record(textarea, {?ELEMENT_BASE(element_textarea), text="", html_encode=true}).
-record(datepicker_textbox, {?ELEMENT_BASE(element_datepicker_textbox), text="", next, html_encode=true, validators=[], options = [{dateFormat, "yy-mm-dd"}]::wf_options() }).
-record(dropdown, {?ELEMENT_BASE(element_dropdown), options=[]::undefined | wf_options(), html_encode=true, postback, delegate, value}).
-record(option, { text="", value="", selected=false }).
-record(checkbox, {?ELEMENT_BASE(element_checkbox), text="", html_encode=true, checked=false, postback, delegate}).
-record(radiogroup, {?ELEMENT_BASE(element_radiogroup), body=[]}).
-record(radio, {?ELEMENT_BASE(element_radio), text="", html_encode=true, value, name, checked=false, postback, delegate}).
-record(password, {?ELEMENT_BASE(element_password), text="", html_encode=true, next, postback, delegate}).
-record(panel, {?ELEMENT_BASE(element_panel), body=""}).
-record(spinner, {?ELEMENT_BASE(element_spinner), image="/nitrogen/spinner.gif"}).
-record(image, {?ELEMENT_BASE(element_image), image="", alt}).
-record(lightbox, {?ELEMENT_BASE(element_lightbox), body="" }).
-record(table, {?ELEMENT_BASE(element_table), rows}).
-record(tablerow, {?ELEMENT_BASE(element_tablerow), cells}).
-record(tableheader, {?ELEMENT_BASE(element_tableheader), text="", html_encode=true, body="", align="left", valign="middle", colspan=1, rowspan=1}).
-record(tablecell, {?ELEMENT_BASE(element_tablecell), text="", html_encode=true, body="", align="left", valign="middle", colspan=1, rowspan=1}).
-record(singlerow, {?ELEMENT_BASE(element_singlerow), cells}). 
-record(file, {?ELEMENT_BASE(element_file), file}).
-record(flash, {?ELEMENT_BASE(element_flash)}).
-record(placeholder, {?ELEMENT_BASE(element_placeholder), body=[]}).
-record(bind, {?ELEMENT_BASE(element_bind), data=[], map=[], transform, acc=[], body=[], empty_body=[]}).
-record(sortblock, {?ELEMENT_BASE(element_sortblock), tag, items=[], group, connect_with_groups=none, handle, delegate=undefined }).
-record(sortitem, {?ELEMENT_BASE(element_sortitem), tag, body=[] }).
-record(draggable, {?ELEMENT_BASE(element_draggable), tag, body=[], group, handle, clone=true, revert=true}).
-record(droppable, {?ELEMENT_BASE(element_droppable), tag, body=[], accept_groups=all, active_class=active, hover_class=hover, delegate=undefined}).
-record(gravatar, {?ELEMENT_BASE(element_gravatar), email="", size="80", rating="g", default=""}).
-record(inplace_textbox, {?ELEMENT_BASE(element_inplace_textbox), tag, text="", html_encode=true, start_mode=view, validators=[], delegate=undefined}).
-record(wizard, {?ELEMENT_BASE(element_wizard), tag, titles, steps }).
-record(upload, {?ELEMENT_BASE(element_upload), delegate, tag, show_button=true, button_text="Upload" }).
-record(sparkline, {?ELEMENT_BASE(element_sparkline), type, values, options }).

%% 960.gs Grid
-record(grid,  {?ELEMENT_BASE(element_grid), type, columns,  alpha, omega, push, pull, prefix, suffix, body}).
-record(container_12,  {?ELEMENT_BASE(element_grid), type=container, columns=12, alpha, omega, push, pull, prefix, suffix, body}).
-record(container_16,  {?ELEMENT_BASE(element_grid), type=container, columns=16, alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_1,  {?ELEMENT_BASE(element_grid), type=grid, columns=1,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_2,  {?ELEMENT_BASE(element_grid), type=grid, columns=2,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_3,  {?ELEMENT_BASE(element_grid), type=grid, columns=3,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_4,  {?ELEMENT_BASE(element_grid), type=grid, columns=4,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_5,  {?ELEMENT_BASE(element_grid), type=grid, columns=5,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_6,  {?ELEMENT_BASE(element_grid), type=grid, columns=6,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_7,  {?ELEMENT_BASE(element_grid), type=grid, columns=7,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_8,  {?ELEMENT_BASE(element_grid), type=grid, columns=8,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_9,  {?ELEMENT_BASE(element_grid), type=grid, columns=9,  alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_10, {?ELEMENT_BASE(element_grid), type=grid, columns=10, alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_11, {?ELEMENT_BASE(element_grid), type=grid, columns=11, alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_12, {?ELEMENT_BASE(element_grid), type=grid, columns=12, alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_13, {?ELEMENT_BASE(element_grid), type=grid, columns=13, alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_14, {?ELEMENT_BASE(element_grid), type=grid, columns=14, alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_15, {?ELEMENT_BASE(element_grid), type=grid, columns=15, alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_16, {?ELEMENT_BASE(element_grid), type=grid, columns=16, alpha, omega, push, pull, prefix, suffix, body}).
-record(grid_clear,  {?ELEMENT_BASE(element_grid), type=clear, columns,  alpha, omega, push, pull, prefix, suffix, body}).

-type wf_grid_element() ::
    #grid{} | #container_12{} | #container_16{} | #grid_1{} | #grid_2{} |
    #grid_3{} | #grid_4{} | #grid_5{} | #grid_6{} | #grid_7{} | #grid_8{} |
    #grid_9{} | #grid_10{} | #grid_11{} | #grid_12{} | #grid_13{} | #grid_14{} |
    #grid_15{} | #grid_16{} | #grid_clear{}.

%%% HTML aliases %%%
-record(ul, {?ELEMENT_BASE(element_ul), body=[]}).
-record(ol, {?ELEMENT_BASE(element_ol), body=[]}).
-record(li, {?ELEMENT_BASE(element_li), body=[], text="", html_encode=true}).
-record(img, {?ELEMENT_BASE(element_img), src="", alt, width="", height=""}).
-record(a, {?ELEMENT_BASE(element_a), text="", body="", html_encode=true, href="javascript:", postback}).

%%% Type for elements.
-type wf_element() ::
        #elementbase{} | #template{} | #function_el{} | #body{} | #h1{} |
        #h2{} | #h3{} | #h4{} | #list{} | #listitem{} | #br{} | #hr{} | #p{} |
        #label{} | #value{} | #link{} | #error{} | #span{} | #button{} |
        #literal{} | #textbox{} | #hidden{} | #textarea{} |
        #datepicker_textbox{} | #dropdown{} | #option{} | #checkbox{} |
        #radiogroup{} | #radio{} | #password{} | #panel{} | #spinner{} |
        #image{} | #lightbox{} | #table{} | #tablerow{} | #tableheader{} |
        #tablecell{} | #singlerow{} | #file{} | #flash{} | #placeholder{} |
        #bind{} | #sortblock{} | #sortitem{} | #draggable{} | #droppable{} |
        #gravatar{} | #inplace_textbox{} | #wizard{} | #upload{} |
        #sparkline{} | #ul{} | #ol{} | #li{} | #img{} | #a{} |
        wf_grid_element().

%%% Actions %%%
-define(ACTION_BASE(Module), is_action=is_action, module=Module :: atom(), anchor, trigger::undefined | wf_triggerpath(), target::undefined | wf_targetpath(), actions :: undefined | wf_actions(), show_if=true :: boolean()).
-record(actionbase, {?ACTION_BASE(undefined)}).
-record(wire, {?ACTION_BASE(action_wire)}).
-record(update, {?ACTION_BASE(action_update), type=update, elements=[]}).
-record(comet, {?ACTION_BASE(action_comet), pool=undefined, scope=local, function, dying_message}).
-record(continue, {?ACTION_BASE(action_continue), function, delegate, tag, timeout}).
-record(api, {?ACTION_BASE(action_api), name, tag, delegate }).
-record(function, {?ACTION_BASE(action_function), function }).
-record(set, {?ACTION_BASE(action_set), value}).
-record(redirect, {?ACTION_BASE(action_redirect), url}).
-record(event, {?ACTION_BASE(action_event), type=default, keycode=undefined, delay=0, postback, validation_group, delegate, extra_param}).
-record(validate, {?ACTION_BASE(action_validate), on=submit, success_text=" ", group, validators, attach_to }).
-record(validation_error, {?ACTION_BASE(action_validation_error), text="" }).
-record(alert, {?ACTION_BASE(action_alert), text=""}).
-record(confirm, {?ACTION_BASE(action_confirm), text=""::string(), postback, delegate}).
-record(script, {?ACTION_BASE(action_script), script}).
-record(disable_selection, {?ACTION_BASE(action_disable_selection)}).
-record(jquery_effect, {?ACTION_BASE(action_jquery_effect), type, effect, speed::undefined | wf_speed(), options=[]::wf_options(), class::undefined | wf_class(), easing::undefined | wf_easing()}).
-record(show, {?ACTION_BASE(action_show), effect=none, options=[], speed=500}).
-record(hide, {?ACTION_BASE(action_hide), effect=none, options=[], speed=500}).
-record(appear, {?ACTION_BASE(action_appear), speed=500}).
-record(fade, {?ACTION_BASE(action_fade), speed=500}).
-record(effect, {?ACTION_BASE(action_effect), effect=none, options=[], speed=500}).
-record(toggle, {?ACTION_BASE(action_toggle), effect=none, options=[], speed=500}).
-record(add_class, {?ACTION_BASE(action_add_class), class=none, speed=0}).
-record(remove_class, {?ACTION_BASE(action_remove_class), class=none, speed=0}).
-record(animate, {?ACTION_BASE(action_animate), options=[], speed=500, easing=swing}).
-record(buttonize, {?ACTION_BASE(action_buttonize)}).

%%% Type for actions.
-type wf_action() ::
        #actionbase{} | #wire{} | #update{} | #comet{} | #continue{} | #api{} |
        #function{} | #set{} | #redirect{} | #event{} | #validate{} |
        #validation_error{} | #alert{} | #confirm{} | #script{} |
        #disable_selection{} | #jquery_effect{} | #show{} | #hide{} |
        #appear{} | #fade{} | #effect{} | #toggle{} | #add_class{} |
        #remove_class{} | #animate{} | #buttonize{}.

%%% Validators %%%
-define(VALIDATOR_BASE(Module), ?ACTION_BASE(Module), text="Failed.":: iodata()).
-record(validatorbase, {?VALIDATOR_BASE(undefined)}).
-record(is_required, {?VALIDATOR_BASE(validator_is_required)}).
-record(is_email, {?VALIDATOR_BASE(validator_is_email)}).
-record(is_integer, {?VALIDATOR_BASE(validator_is_integer)}).
-record(min_length, {?VALIDATOR_BASE(validator_min_length), length}).
-record(max_length, {?VALIDATOR_BASE(validator_max_length), length}).
-record(confirm_password, {?VALIDATOR_BASE(validator_confirm_password), password}).
-record(custom, {?VALIDATOR_BASE(validator_custom), function, tag }).
-record(js_custom, {?VALIDATOR_BASE(validator_js_custom), function, args="{}" }).

%%% Type for validators.
-type wf_validator() ::
        #validatorbase{} | #is_required{} | #is_email{} | #is_integer{} |
        #min_length{} | #max_length{} | #confirm_password{} | #custom{} |
        #js_custom{}.

%%% Union types :
%%% Type for render input.
-type(wf_render_data() :: undefined | iodata() | wf_element() | [undefined | wf_element() | iodata()]).
%%% Type for render_actions input. iodata() is rendered as a script.
-type(wf_render_action_data() :: undefined | iodata() | wf_action() | [undefined | wf_action() | iodata()]).

-endif.
