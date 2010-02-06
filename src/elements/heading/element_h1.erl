% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_h1).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, h1).

-spec(render/2::(string(), #h1{}) -> iodata()).
render(ControlID, Record) -> 
	Content = [
		wf:html_encode(Record#h1.text, Record#h1.html_encode),
		wf:render(Record#h1.body)
	],
	wf_tags:emit_tag(h1, Content, [
		{id, ControlID},
		{class, [h1, Record#h1.class]},
		{style, Record#h1.style}
	]).
