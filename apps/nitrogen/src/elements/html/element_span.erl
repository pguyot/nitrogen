% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_span).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, span).

-spec render_element(#span{}) -> wf_render_data().
render_element(Record) -> 
    Content = [
        wf:html_encode(Record#span.text, Record#span.html_encode),
        Record#span.body
    ],
    wf_tags:emit_tag(span, Content, [
        {class, Record#span.class}, 
        {style, Record#span.style},
        {title, Record#span.title} | Record#span.attrs]).
