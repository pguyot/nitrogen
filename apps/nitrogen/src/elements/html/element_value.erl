% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_value).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, value).

-spec render_element(#value{}) -> iodata().
render_element(Record) -> 
    Text = wf:html_encode(Record#value.text, Record#value.html_encode),
    wf_tags:emit_tag(span, Text, [
        {class, [value, Record#value.class]},
        {style, Record#value.style},
        {title, Record#value.title} | Record#value.attrs]).
