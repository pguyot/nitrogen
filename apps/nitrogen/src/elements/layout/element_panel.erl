% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_panel).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, panel).

-spec render_element(#panel{}) -> wf_render_data().
render_element(Record) -> 
    wf_tags:emit_tag('div', Record#panel.body, [
        {class, ["panel", Record#panel.class]},
        {style, Record#panel.style},
        {title, Record#panel.title} | Record#panel.attrs]).
