% Nitrogen Web Framework for Erlang
% Copyright (c) 2009 Semiocast
% See MIT-LICENSE for licensing information.

-module (element_li).
-include ("wf.inc").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, li).

-spec render_element(#li{}) -> wf_render_data().
render_element(#li{
    module = ?MODULE,
    id = Id,
    actions = Actions,
    show_if = ShowIf,
    class = Class,
    style = Style,
    title = Title,
    attrs = Attrs,
    body = Body,
    text = Text,
    html_encode = HTMLEncode}) ->
    element_listitem:render_element(#listitem{
            module = element_listitem,
            id = Id,
            actions = Actions,
            show_if = ShowIf,
            class = Class,
            style = Style,
            title = Title,
            attrs = Attrs,
            body = Body,
            text = Text,
            html_encode = HTMLEncode
        }).
