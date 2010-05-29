-module (wf_convert_test).
-include_lib("eunit/include/eunit.hrl").

html_encode(Str) ->
    iolist_to_binary(wf:html_encode(Str)).
html_encode(Str, Mode) ->
    iolist_to_binary(wf:html_encode(Str, Mode)).

html_encode_test_() ->
    [
        ?_assertEqual(<<"hello world">>, html_encode("hello world")),
        ?_assertEqual(<<"hello &lt; world">>, html_encode("hello < world")),
        ?_assertEqual(<<"hello &amp; world">>, html_encode("hello & world")),
        ?_assertEqual(<<"hello &amp;&lt; world">>, html_encode("hello &< world")),
        ?_assertEqual(<<"hello &lt;js&gt; world">>, html_encode("hello <js> world")),
        ?_assertEqual(<<"hello&nbsp;&amp;&nbsp;world">>, html_encode("hello & world", whites)),
        ?_assertEqual(<<"hello<br/>world">>, html_encode("hello\nworld", whites)),
        ?_assertEqual(<<"hello&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;world">>, html_encode("hello\tworld", whites)),
        ?_assertEqual(<<"hello world">>, html_encode(<<"hello world">>)),
        ?_assertEqual(<<"hello &lt; world">>, html_encode(<<"hello < world">>)),
        ?_assertEqual(<<"hello &amp; world">>, html_encode(<<"hello & world">>)),
        ?_assertEqual(<<"hello &amp;&lt; world">>, html_encode(<<"hello &< world">>)),
        ?_assertEqual(<<"hello &lt;js&gt; world">>, html_encode(<<"hello <js> world">>)),
        ?_assertEqual(<<"hello&nbsp;&amp;&nbsp;world">>, html_encode(<<"hello & world">>, whites)),
        ?_assertEqual(<<"hello<br/>world">>, html_encode(<<"hello\nworld">>, whites)),
        ?_assertEqual(<<"hello&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;world">>, html_encode(<<"hello\tworld">>, whites))
    ].

