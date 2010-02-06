% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_h4).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, h4).

-spec(render/2::(string(), #h4{}) -> iodata()).
render(ControlID, Record) ->
	Content = [
		wf:html_encode(Record#h4.text, Record#h4.html_encode),
		wf:render(Record#h4.body)
	],
	wf_tags:emit_tag(h4, Content, [
		{id, ControlID},
		{class, [h4, Record#h4.class]},
		{style, Record#h4.style}
	]).
