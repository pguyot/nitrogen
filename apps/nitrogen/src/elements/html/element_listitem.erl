% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_listitem).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, listitem).

-spec render_element(#listitem{}) -> wf_render_data().
render_element(Record) -> 
    Body = [
        wf:html_encode(Record#listitem.text, Record#listitem.html_encode),
        Record#listitem.body
    ],

    wf_tags:emit_tag(li, Body, [
        {class, [listitem, Record#listitem.class]},
        {style, Record#listitem.style},
        {title, Record#listitem.title} | Record#listitem.attrs]).
