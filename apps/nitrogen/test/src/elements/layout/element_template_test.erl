-module(element_template_test).
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

-export([placeholder_1/0, placeholder_2/0, placeholder_bound/1]).

-ifndef(TEST_RSRC_PATH).
-define(TEST_RSRC_PATH, "test/data").
-endif.

render(File) ->
    render(File, []).
render(File, Bindings) ->
    wf_context:init_context(mock_request_bridge, mock_response_bridge),
    wf_context:page_module(?MODULE),
    FilePath = filename:join([?TEST_RSRC_PATH, "templates", File]),
    Record = #template{file=FilePath, bindings=Bindings},
    R = wf_render_elements:render_elements([Record]),
    ?assertMatch({ok, _Html}, R),
    {ok, Html} = R,
    iolist_to_binary(Html).

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
