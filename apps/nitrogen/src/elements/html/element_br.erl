% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_br).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, br).

-spec render_element(#br{}) -> iodata().
render_element(Record) -> 
    wf_tags:emit_tag(br, [
        {class, [br, Record#br.class]}, 
        {style, Record#br.style},
        {title, Record#br.title} | Record#br.attrs]).
