% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_h2).
-include_lib ("wf.hrl").
-compile(export_all).

reflect() -> record_info(fields, h2).

render_element(Record) -> 
    Content = [
        wf:html_encode(Record#h2.text, Record#h2.html_encode),
        Record#h2.body
    ],
    wf_tags:emit_tag(h2, Content, [
        {class, [h2, Record#h2.class]},
        {style, Record#h2.style}
    ]).
