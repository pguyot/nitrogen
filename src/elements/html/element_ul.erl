% Nitrogen Web Framework for Erlang
% Copyright (c) 2009 Semiocast
% See MIT-LICENSE for licensing information.

-module (element_ul).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, ul).

-spec(render/2::(string(), #ul{}) -> iodata()).
render(ControlID, #ul{
    module = ?MODULE,
    id = Id,
    actions = Actions,
    show_if = ShowIf,
    class = Class,
    style = Style,
    title = Title,
    attrs = Attrs,
    body = Body}) ->
    element_list:render(ControlID, #list{
            module = element_list,
            id = Id,
            actions = Actions,
            show_if = ShowIf,
            class = Class,
            style = Style,
            title = Title,
            attrs = Attrs,
            body = Body,
            numbered = false
        }).
