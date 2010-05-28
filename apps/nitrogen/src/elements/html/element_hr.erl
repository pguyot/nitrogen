% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_hr).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, hr).

-spec render_element(#hr{}) -> iodata().
render_element(Record) -> 
    wf_tags:emit_tag(hr, [
        {size, 1},
        {class, [hr, Record#hr.class]},
        {style, Record#hr.style},
        {title, Record#hr.title} | Record#hr.attrs]).
