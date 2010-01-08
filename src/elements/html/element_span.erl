% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_span).
-include ("wf.inc").
-export([render/2, reflect/0]).

-spec(reflect/0::() -> [atom()]).
reflect() -> record_info(fields, span).

%%% CODE %%%

-spec(render/2::(wf_id(), #span{}) -> iodata()).
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
