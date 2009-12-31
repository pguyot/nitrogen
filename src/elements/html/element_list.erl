% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_list).
-include ("wf.inc").
-compile(export_all).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, list).

-spec(render/2::(string(), #list{}) -> iodata()).
render(ControlID, Record) -> 
	Tag = case Record#list.numbered of 
		true -> ol;
		_ -> ul
	end,

	Content = wf:render(Record#list.body),
	wf_tags:emit_tag(Tag, Content, [
		{id, ControlID},
		{class, [list, Record#list.class]},
		{style, Record#list.style},
	    {title, Record#list.title} | Record#list.attrs]).
