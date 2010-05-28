% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_literal).
-include_lib ("wf.hrl").
-export([reflect/0, render_element/1]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, literal).

-spec render_element(#literal{}) -> iodata().
render_element(Record) -> 
    wf:html_encode(Record#literal.text, Record#literal.html_encode).
