% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (default_log_handler).
-behaviour (log_handler).
-export ([
    init/2, 
    finish/2,
    info/3, 
    warning/3, 
    error/3
]).

-spec init(any(), State) -> {ok, State}.
init(_Config, State) -> 
    {ok, State}.

-spec finish(any(), State) -> {ok, State}.
finish(_Config, State) -> 
    {ok, State}.

-spec info(string(), any(), State) -> {ok, State}.
info(S, _Config, State) -> 
    error_logger:info_msg(lists:append(S, "\n")),
    {ok, State}.

-spec warning(string(), any(), State) -> {ok, State}.
warning(S, _Config, State) -> 
    error_logger:warning_msg(lists:append(S, "\n")),
    {ok, State}.

-spec error(string(), any(), State) -> {ok, State}.
error(S, _Config, State) -> 
    error_logger:error_msg(lists:append(S, "\n")),
    {ok, State}.
