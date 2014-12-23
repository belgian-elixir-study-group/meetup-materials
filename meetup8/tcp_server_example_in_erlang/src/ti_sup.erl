-module(ti_sup).

-behaviour(supervisor).

%% API
-export([start_link/1, start_child/0]).

%% Supervisor callbacks
-export([init/1]).


%% ===================================================================
%% API functions
%% ===================================================================

start_link(LSock) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [LSock]).

start_child() ->
    supervisor:start_child(?MODULE, []).


%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([LSock]) ->

    Server = {
      ti_server,                        % term that the supervisor uses to identify the specification internally (i.e. server type name)
      {ti_server, start_link, [LSock]}, % how to start the process, MFA: Module, Function, Arguments
      temporary,                        % How to restart:  temporary: processes that should never be restarted
      brutal_kill,                      % How to shutdown: brutal_kill means the child process is unconditionally terminated using exit
      worker,                           % TYPE, this is a worker (supervisor can supervise other supervisors)
      [ti_server]                       % modules that the process depends on
    },

    Children = [Server],

    RestartStrategy = {
      simple_one_for_one, % simple_one_for_one is a simplified one_for_one supervisor,
                          % where all child processes are dynamically added instances of the same process.
      0,                  % MaxR:   If more than MaxR number of restarts occur in the last MaxT seconds,
      1                   % MaxT:   then the supervisor terminates all the child processes and then itself.
    },

    {ok, {RestartStrategy, Children}}.

