% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (wf_event).
-include_lib ("wf.hrl").
-export ([
    update_context_with_event/0,
    generate_postback_script/5,
    generate_system_postback_script/4,
    serialize_event_context/4
]).

% This module looks at the incoming request for 'eventContext' and 'pageContext' params. 
% If found, then it updates the current context, putting values into event_context
% and page_context, respectively.
%
% If not found, then it creates #event_context and #page_context records with
% values for a first request.


update_context_with_event() ->
    SerializedEvent = wf:q(eventContext),
    Event = wf_pickle:depickle(SerializedEvent),

    % Update the Context...
    InitialType = wf_context:type(),
    IsPostback = is_record(Event, event_context),
    case {InitialType, IsPostback} of
        {first_request, false}      -> update_context_for_first_request();
        {first_request, true}       -> update_context_for_postback_request(Event);
        {static_file, _}            -> update_context_for_static_file();
        {{static_file, Options}, _} -> update_context_for_static_file(Options);
        {{redirect, Code}, _}       -> update_context_for_redirect(Code)
    end.

update_context_for_static_file() ->
    ok.

update_context_for_static_file(_Options) ->
    ok.

update_context_for_redirect(_Code) ->
    ok.

update_context_for_first_request() ->
    Module = wf_context:page_module(),
    wf_context:event_module(Module),
    wf_context:type(first_request),
    wf_context:anchor("page"),
    ok.

update_context_for_postback_request(Event) ->
    Anchor = Event#event_context.anchor,
    ValidationGroup = Event#event_context.validation_group,
    wf_context:type(postback_request),
    wf_context:event_context(Event),
    wf_context:anchor(Anchor),
    wf_context:event_validation_group(ValidationGroup),
    ok.

generate_postback_script(undefined, _Anchor, _ValidationGroup, _Delegate, _ExtraParam) -> [];
generate_postback_script(Postback, Anchor, ValidationGroup, Delegate, ExtraParam) ->
    PickledPostbackInfo = serialize_event_context(Postback, Anchor, ValidationGroup, Delegate),
    wf:f("Nitrogen.$queue_event('~s', '~s', ~s);", [ValidationGroup, PickledPostbackInfo, ExtraParam]).

generate_system_postback_script(undefined, _Anchor, _ValidationGroup, _Delegate) -> [];
generate_system_postback_script(Postback, Anchor, ValidationGroup, Delegate) ->
    PickledPostbackInfo = serialize_event_context(Postback, Anchor, ValidationGroup, Delegate),
    wf:f("Nitrogen.$queue_system_event('~s');", [PickledPostbackInfo]).

serialize_event_context(Tag, Anchor, ValidationGroup, Delegate) ->
    PageModule = wf_context:page_module(),
    EventModule = wf:coalesce([Delegate, PageModule]),
    Event = #event_context {
        module = EventModule,
        tag = Tag,
        anchor = Anchor,
        validation_group = ValidationGroup
    },
    wf_pickle:pickle(Event).
