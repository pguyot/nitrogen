% Nitrogen Web Framework for Erlang
% Copyright (c) 2009 Semiocast
% See MIT-LICENSE for licensing information.

-module (element_ol).
-include ("wf.inc").
-compile(export_all).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, ol).

-spec render_element(#ol{}) -> iodata().
render_element(#ol{
    module = ?MODULE,
    id = Id,
    actions = Actions,
    show_if = ShowIf,
    class = Class,
    style = Style,
    title = Title,
    attrs = Attrs,
    body = Body}) ->
    element_list:render_element(#list{
            module = element_list,
            id = Id,
            actions = Actions,
            show_if = ShowIf,
            class = Class,
            style = Style,
            title = Title,
            attrs = Attrs,
            body = Body,
            numbered = true
        }).
