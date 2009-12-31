% Nitrogen Web Framework for Erlang
% Copyright (c) 2009 Semiocast
% See MIT-LICENSE for licensing information.

-module (element_img).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, img).

-spec(render/2::(string(), #img{}) -> iodata()).
render(ControlID, #img{
    module = ?MODULE,
    id = Id,
    actions = Actions,
    show_if = ShowIf,
    class = Class,
    style = Style,
    title = Title,
    attrs = Attrs0,
    src = Source,
    alt = Alt,
    width = Width,
    height = Height}) ->
    Attrs1 = case Width of
        [] -> Attrs0;
        _ -> [{width, Width} | Attrs0]
    end,
    Attrs2 = case Height of
        [] -> Attrs1;
        _ -> [{height, Height} | Attrs1]
    end,
    element_image:render(ControlID, #image{
            module = element_image,
            id = Id,
            actions = Actions,
            show_if = ShowIf,
            class = Class,
            style = Style,
            title = Title,
            attrs = Attrs2,
            image = Source,
            alt = Alt
        }).
