-module(render_test_helper).
-include_lib("eunit/include/eunit.hrl").
-export([
    render_action/1,
    render_element/1
    ]).

render_action(Record) ->
    wf_context:init_context(mock_request_bridge, mock_response_bridge),
    R = wf_render_actions:render_actions([Record], anchor),
    ?assertMatch({ok, _ActionScript}, R),
    {ok, ActionScript} = R,
    iolist_to_binary(ActionScript).

render_element(Record) ->
    wf_context:init_context(mock_request_bridge, mock_response_bridge),
    R = wf_render_elements:render_elements([Record]),
    ?assertMatch({ok, _Html}, R),
    {ok, Html} = R,
    Result0 = re:replace(Html, <<"wfid_temp[0-9]+">>, <<"wfid_tempID">>, [global]),
    iolist_to_binary(Result0).
