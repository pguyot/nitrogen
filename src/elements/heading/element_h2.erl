% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_h2).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, h2).

-spec(render/2::(string(), #h2{}) -> iodata()).
render(ControlID, Record) -> 
	Content = [
		wf:html_encode(Record#h2.text, Record#h2.html_encode),
		wf:render(Record#h2.body)
	],
	wf_tags:emit_tag(h2, Content, [
		{id, ControlID},
		{class, [h2, Record#h2.class]},
		{style, Record#h2.style}
	]).
