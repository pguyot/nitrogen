% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_listitem).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, listitem).

-spec(render/2::(string(), #listitem{}) -> iodata()).
render(ControlID, Record) -> 
	Content = [
		wf:html_encode(Record#listitem.text, Record#listitem.html_encode),
		wf:render(Record#listitem.body)
	],

	wf_tags:emit_tag(li, Content, [
		{id, ControlID},
		{class, [listitem, Record#listitem.class]},
		{style, Record#listitem.style},
	    {title, Record#listitem.title} | Record#listitem.attrs]).
