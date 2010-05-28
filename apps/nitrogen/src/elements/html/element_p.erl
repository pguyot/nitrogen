% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_p).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, p).

-spec render_element(#p{}) -> wf_render_data().
render_element(Record) -> 
    wf_tags:emit_tag(p, Record#p.body, [
        {class, [p, Record#p.class]},
        {style, Record#p.style},
        {title, Record#p.title} | Record#p.attrs]).

