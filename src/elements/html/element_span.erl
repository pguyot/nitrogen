% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_span).
-include ("wf.inc").
-compile(export_all).

reflect() -> record_info(fields, span).

%%% CODE %%%

render(ControlID, Record) -> 
	Content = [
		wf:html_encode(Record#span.text, Record#span.html_encode),
		wf:render(Record#span.body)
	],
	wf_tags:emit_tag(span, Content, [
        {id, ControlID},
        {class, Record#span.class}, 
        {style, Record#span.style},
	    {title, Record#span.title} | Record#span.attrs]).
