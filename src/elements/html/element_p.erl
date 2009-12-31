% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_p).
-compile(export_all).
-include ("wf.inc").

reflect() -> record_info(fields, p).

render(ControlID, Record) -> 
	Content = wf:render(Record#p.body),
	wf_tags:emit_tag(p, Content, [
		{id, ControlID}, 
		{class, [p, Record#p.class]},
		{style, Record#p.style},
	    {title, Record#p.title} | Record#p.attrs]).
	
