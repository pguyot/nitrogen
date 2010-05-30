-module(extended_route_handler_test).
-include_lib("eunit/include/eunit.hrl").

% mock response_bridge
-export([
    path/1,
    uri/1
    ]).

path({?MODULE, Path}) -> Path.
uri({?MODULE, Path}) -> "http://foo.com" ++ Path.

simple_module_test() ->
    wf_context:init_context({?MODULE, "/view/foo"}, mock_response_bridge),
    extended_route_handler:init([
        {"/view", ?MODULE}
    ], state),
    ?assertEqual(?MODULE, wf_context:page_module()),
    ?assertEqual("/foo", wf_context:path_info()).

simple_static_file_test() ->
    wf_context:init_context({?MODULE, "/downloads/foo"}, mock_response_bridge),
    extended_route_handler:init([
        {"/downloads", static_file}
    ], state),
    ?assertEqual(static_file, wf_context:page_module()),
    ?assertEqual("/downloads/foo", wf_context:path_info()).

docroot_static_file_test() ->
    wf_context:init_context({?MODULE, "/downloads/foo"}, mock_response_bridge),
    extended_route_handler:init([
        {"/downloads", static_file, "/path/to/downloads"}
    ], state),
    ?assertEqual({static_file, "/path/to/downloads"}, wf_context:page_module()),
    ?assertEqual("/foo", wf_context:path_info()).

do_not_match_any_prefix_test() ->
    wf_context:init_context({?MODULE, "/foobar"}, mock_response_bridge),
    extended_route_handler:init([
        {"/foo", ?MODULE}
    ], state),
    ?assertEqual(file_not_found_page, wf_context:page_module()),
    ?assertEqual("/foobar", wf_context:path_info()).

nonexisting_module_test() ->
    wf_context:init_context({?MODULE, "/view/foo"}, mock_response_bridge),
    extended_route_handler:init([
        {"/view", nonexisting_module}
    ], state),
    ?assertEqual(file_not_found_page, wf_context:page_module()),
    ?assertEqual("/view/foo", wf_context:path_info()).

default_route_test() ->
    wf_context:init_context({?MODULE, "/stuff"}, mock_response_bridge),
    extended_route_handler:init([
        {"/view", ?MODULE}
    ], state),
    ?assertEqual(file_not_found_page, wf_context:page_module()),
    ?assertEqual("/stuff", wf_context:path_info()).

redirect_test() ->
    wf_context:init_context({?MODULE, "/static/bar"}, mock_response_bridge),
    extended_route_handler:init([
        {"/static/(.+)$", redirect, "/\\1"}
    ], state),
    ?assertEqual({redirect, 302}, wf_context:page_module()),
    ?assertEqual("http://foo.com/bar", wf_context:path_info()).

order_1_test() ->
    wf_context:init_context({?MODULE, "/one/two/three"}, mock_response_bridge),
    extended_route_handler:init([
        {"/one/two", ?MODULE},
        {"/one", static_file}
    ], state),
    ?assertEqual(?MODULE, wf_context:page_module()),
    ?assertEqual("/three", wf_context:path_info()).

order_2_test() ->
    wf_context:init_context({?MODULE, "/one/two/three"}, mock_response_bridge),
    extended_route_handler:init([
        {"/one", static_file},
        {"/one/two", ?MODULE}
    ], state),
    ?assertEqual(static_file, wf_context:page_module()),
    ?assertEqual("/one/two/three", wf_context:path_info()).
