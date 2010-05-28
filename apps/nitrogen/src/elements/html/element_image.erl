% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_image).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, image).

-spec render_element(#image{}) -> iodata().
render_element(Record) ->
    Attributes = [
        {class, [image, Record#image.class]},
        {style, Record#image.style},
        {src, Record#image.image},
        {title, Record#image.title} | Record#image.attrs],

    FinalAttributes = case Record#image.alt of
        undefined -> Attributes;
        ImageAlt -> [{alt, ImageAlt}|Attributes] 
    end,

    wf_tags:emit_tag(img, FinalAttributes).
