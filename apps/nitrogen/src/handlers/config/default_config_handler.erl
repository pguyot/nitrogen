% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (default_config_handler).
-include_lib ("wf.hrl").
-behaviour (config_handler).
-export ([
    init/2, 
    finish/2,
    get_value/4,
    get_values/4 
]).

init(_Config, _State) -> 
    {ok, []}.

finish(_Config, _State) -> 
    {ok, []}.

get_value(Key, DefaultValue, Config, State) ->
    case get_values(Key, [DefaultValue], Config, State) of
        [Value] -> 
            Value;
        Values ->
            error_logger:error_msg("Too many matching config values for key: ~p~n", [Key]),
            throw({nitrogen_error, too_many_matching_values, Key, Values})
    end.

get_values(Key, DefaultValues, {Application, Override}, _State) ->
    get_values0(Key, DefaultValues, Application, Override);
get_values(Key, DefaultValues, _Config, _State) ->
    get_values0(Key, DefaultValues, nitrogen, []).

get_values0(Key, DefaultValues, Application, Override) ->
    case lists:keyfind(Key, 1, Override) of
        {Key, Value} -> [Value];
        false ->
            case application:get_env(Application, Key) of
                {ok, Value} -> 
                    [Value];
                undefined ->
                    DefaultValues
            end
    end.
