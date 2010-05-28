% Nitrogen Web Framework for Erlang
% Copyright (c) 2009 Semiocast
% See MIT-LICENSE for licensing information.

-module (element_a).
-include ("wf.inc").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, a).

-spec render_element(#a{}) -> wf_render_data().
render_element(#a{
    module = ?MODULE,
    id = Id,
    actions = Actions,
    show_if = ShowIf,
    class = Class,
    style = Style,
    title = Title,
    attrs = Attrs,
    text = Text,
    body = Body,
    html_encode = HTMLEncode,
    href = HREF,
    postback = Postback}) ->
    element_link:render_element(#link{
            module = element_link,
            id = Id,
            actions = Actions,
            show_if = ShowIf,
            class = Class,
            style = Style,
            title = Title,
            attrs = Attrs,
            text = Text,
            body = Body,
            html_encode = HTMLEncode,
            url = HREF,
            postback = Postback
        }).
