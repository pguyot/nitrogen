% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (action_redirect).
-include_lib ("wf.hrl").
-export([render_action/1, redirect/1, redirect_to_login/1, redirect_from_login/1]).

-spec render_action(#redirect{}) -> wf_render_action_data().
render_action(Record) ->
    DestinationUrl = Record#redirect.url,
    wf:f("window.location=\"~s\";", [wf:js_escape(DestinationUrl)]).

% redirect to a given URL. This function is called from wf:redirect*/1
% If the request is a first_request (i.e. not AJAX), we redirect using
% Location: header. Otherwise, we wire a redirect action.
% This function always return the empty list.
-spec redirect(iodata()) -> [].
redirect(Url) -> 
    case wf_context:type() of
        first_request ->
            Code = wf_convert:redirect_status_to_code(temp),
            wf:status_code(Code),
            wf:header(location, Url);
        postback_request ->
            wf:wire(#redirect { url=Url })
    end,
    [].

-spec redirect_to_login(iodata()) -> iodata().
redirect_to_login(LoginUrl) ->
    % Assemble the original
    Request = wf_context:request_bridge(),
    OriginalURI = Request:uri(),
    PickledURI = wf:pickle(OriginalURI),
    redirect(LoginUrl ++ "?x=" ++ wf:to_list(PickledURI)).

-spec redirect_from_login(iodata()) -> iodata().
redirect_from_login(DefaultUrl) ->	
    PickledURI = wf:q(x),
    case wf:depickle(PickledURI) of
        undefined -> redirect(DefaultUrl);
        Other -> redirect(Other)
    end.
