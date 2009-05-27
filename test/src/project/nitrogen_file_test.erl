-module (nitrogen_file_test).
-compile([export_all]).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").

-include("wf.inc").

some_contents() ->
  "this is some content with repeating repeating information repeating a bunch".

read_file_contents(Filename) ->
    {ok, Bin} = file:read_file(Filename),
    Bin.

create_test_page() ->
    nitrogen_file:create_page("web/foo","/tmp"),
    read_file_contents("/tmp/web_foo.erl").

result_1() ->
    <<"-module (web_foo).\n-include_lib (\"nitrogen/include/wf.inc\").\n-compile(export_all).\n\nmain() -> \n\t#template { file=\"./wwwroot/template.html\"}.\n\ntitle() ->\n\t\"web_foo\".\n\nbody() ->\n\t#label{text=\"web_foo body.\"}.\n\t\nevent(_) -> ok.">>.

basic_test_() ->
  [?_assertEqual(result_1(), create_test_page())
%% Cannot run this due to interface not exporting replace_content
%%   ?_assertEqual(<<"web_index web_cat web_dog">>,
%%       nitrogen_file:replace_content([{"PAGE","web_index"},{"TEST","web_dog"},{"LOC","web_cat"}],"PAGE LOC TEST"))
  ].

