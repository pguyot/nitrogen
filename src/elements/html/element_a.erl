% Nitrogen Web Framework for Erlang
% Copyright (c) 2009 Semiocast
% See MIT-LICENSE for licensing information.

-module (element_a).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, a).

-spec(render/2::(string(), #a{}) -> iodata()).
render(ControlID, #a{
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
    element_link:render(ControlID, #link{
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
