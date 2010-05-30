-module(named_route_handler_test).
-include_lib("eunit/include/eunit.hrl").

-export([
    path/1
    ]).

path({?MODULE, Path}) -> Path.

simple_module_test() ->
    wf_context:init_context({?MODULE, "/view/foo"}, mock_response_bridge),
    named_route_handler:init([
        {"/view", ?MODULE}
    ], state),
    ?assertEqual(?MODULE, wf_context:page_module()),
    ?assertEqual("/foo", wf_context:path_info()).

simple_static_file_test() ->
    wf_context:init_context({?MODULE, "/downloads/foo"}, mock_response_bridge),
    named_route_handler:init([
        {"/downloads", static_file}
    ], state),
    ?assertEqual(static_file, wf_context:page_module()),
    ?assertEqual("/downloads/foo", wf_context:path_info()).

match_any_prefix_test() ->
    wf_context:init_context({?MODULE, "/foobar"}, mock_response_bridge),
    named_route_handler:init([
        {"/foo", ?MODULE}
    ], state),
    ?assertEqual(?MODULE, wf_context:page_module()),
    ?assertEqual("bar", wf_context:path_info()).

nonexisting_module_test() ->
    wf_context:init_context({?MODULE, "/view/foo"}, mock_response_bridge),
    named_route_handler:init([
        {"/view", nonexisting_module}
    ], state),
    ?assertEqual(file_not_found_page, wf_context:page_module()),
    ?assertEqual("/view/foo", wf_context:path_info()).

default_route_test() ->
    wf_context:init_context({?MODULE, "/stuff"}, mock_response_bridge),
    named_route_handler:init([
        {"/view", ?MODULE}
    ], state),
    ?assertEqual(static_file, wf_context:page_module()),
    ?assertEqual("/stuff", wf_context:path_info()).

order_1_test() ->
    wf_context:init_context({?MODULE, "/one/two/three"}, mock_response_bridge),
    named_route_handler:init([
        {"/one/two", ?MODULE},
        {"/one", static_file}
    ], state),
    ?assertEqual(?MODULE, wf_context:page_module()),
    ?assertEqual("/three", wf_context:path_info()).

order_2_test() ->
    wf_context:init_context({?MODULE, "/one/two/three"}, mock_response_bridge),
    named_route_handler:init([
        {"/one", static_file},
        {"/one/two", ?MODULE}
    ], state),
    ?assertEqual(?MODULE, wf_context:page_module()),
    ?assertEqual("/three", wf_context:path_info()).
