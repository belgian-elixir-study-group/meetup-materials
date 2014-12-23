-module(ti_server).

-behaviour(gen_server).

-export([start_link/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {lsock}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link(LSock) ->
  gen_server:start_link(?MODULE, [LSock], []).

%% ===================================================================
%% gen_server callbacks
%% ===================================================================

init([LSock]) ->
    {
      ok,
      #state{lsock = LSock},
      0 % zero timeout!!!
    }.

handle_info({tcp, Socket, RawData}, State) ->
    NewState = handle_data(Socket, RawData, State),
    {noreply, NewState};
handle_info({tcp_closed, _Socket}, State) ->
    {stop, normal, State};
handle_info(timeout, #state{lsock = LSock} = State) ->
    {ok, _Sock} = gen_tcp:accept(LSock),
    ti_sup:start_child(),
    {noreply, State}.

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.
handle_cast(stop, State) ->
    {stop, normal, State}.

terminate(_Reason, _State) ->  ok.

code_change(_OldVsn, State, _Extra) ->  {ok, State}.

%% ===================================================================
%% internal
%% ===================================================================

handle_data(Socket, RawData, State) ->
    gen_tcp:send(Socket, RawData),
    State.
