% Simple Bridge
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (simple_bridge_response).
-include_lib ("simple_bridge.hrl").
-export ([
    make/2,
    behaviour_info/1,
    serve_file_headers/2
]).


make(Module, ResponseData) ->
    try
        make_nocatch(Module, ResponseData)
    catch Type : Error ->
        error_logger:error_msg("Error in simple_bridge_response:make/2 - ~p - ~p~n~p", [Type, Error, erlang:get_stacktrace()]),
        erlang:Type(Error)
    end.

make_nocatch(Mod, ResponseData) ->
    simple_bridge_response_wrapper:new(Mod, ResponseData, #response{}).

behaviour_info(callbacks) -> [
    {build_response, 2} 
];

behaviour_info(_) -> ok.

serve_file_headers(_Path, Options) ->
    %% Compute expires date.
    ExpireHeaderL = case proplists:get_value(expires, Options) of
        undefined -> [];
        ExpiresValue ->
            NowInSeconds = calendar:datetime_to_gregorian_seconds(calendar:local_time()),
            ExpiresDelta = case ExpiresValue of
                never ->
                    365 * 24 * 60 * 60; % rfc2616 says to use 1 year
                already_expired -> 0;
                N when is_integer(N) -> N
            end,
            ExpirationDate = calendar:gregorian_seconds_to_datetime(NowInSeconds + ExpiresDelta),
            ExpirationDateStr = httpd_util:rfc1123_date(ExpirationDate),
            [{"Expires", ExpirationDateStr}]
    end,
    ExpireHeaderL.
