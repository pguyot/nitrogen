% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_h3).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, h3).

-spec(render/2::(string(), #h3{}) -> iodata()).
render(ControlID, Record) -> 
	Content = [
		wf:html_encode(Record#h3.text, Record#h3.html_encode),
		wf:render(Record#h3.body)
	],
	wf_tags:emit_tag(h3, Content, [
		{id, ControlID},
		{class, [h3, Record#h3.class]},
		{style, Record#h3.style}
	]).
