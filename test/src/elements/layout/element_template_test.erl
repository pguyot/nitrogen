-module(element_template_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.inc").

-export([placeholder_1/0, placeholder_2/0, placeholder_bound/1]).

-ifndef(TEST_RSRC_PATH).
-define(TEST_RSRC_PATH, "test/data").
-endif.

render(File) ->
    render(File, []).
render(File, Bindings) ->
    wf:clear_state(),
    wf_query:prepare_request_query_paths([]),
    wf_platform:set_page_module(?MODULE),
    FilePath = filename:join([?TEST_RSRC_PATH, "templates", File]),
    Result = element_template:render(id, #template{file=FilePath, bindings=Bindings}),
    iolist_to_binary(Result).

template_test_() ->
    [
    ?_assertEqual(<<>>,
        render("not_found.html")),
    ?_assertEqual(<<"no placeholder here.">>,
        render("no_placeholder.html")),
    ?_assertEqual(<<"hello there!">>,
        render("single_placeholder.html")),
    ?_assertEqual(<<"hello there!">>,
        render("absolute_pagemodule.html")),
    ?_assertEqual(<<"hello there!">>,
        render("two_placeholders.html")),
    ?_assertEqual(<<"Hello Joe!\nGlad to see you!">>,
        render("bindings_test.html", [{'Name', "Joe"}]))
    ].

placeholder_1() ->
    "there".

placeholder_2() ->
    "hello".

placeholder_bound(Name) ->
    [<<"Hello ">>, Name, "!"].
