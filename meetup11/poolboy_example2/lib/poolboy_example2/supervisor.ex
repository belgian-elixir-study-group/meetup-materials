defmodule PoolboyExample2.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts)
  end

  def init(_opts) do

    pool_options = [
      name: {:local, :my_pool},
      worker_module: PoolboyExample2.Worker,
      size: 5,
      max_overflow: 0
    ]

    # default_specs = worker(PoolboyExample2.Worker, [])

    # poolboy_specs = :poolboy.child_spec(:hello_pool, pool_options, [])

    # IO.inspect default_specs
    # IO.inspect poolboy_specs


    # {
    #   PoolboyExample2.Worker,                      #  a name that is used to identify the child specification internally by the supervisor
    #   {                                            # how the worker should be started
    #     PoolboyExample2.Worker,                    # Module
    #     :start_link,                               # Function
    #     []                                         # Arguments
    #   },
    #   :permanent,                                  # when a terminated child process should be restarted
    #   5000,                                        # how a child process should be terminated.
    #   :worker,                                     # worker or supervisor
    #   [PoolboyExample2.Worker]                     # modules we depend on
    # }

    # {
    #   :hello_pool,                                #  a name that is used to identify the child specification internally by the supervisor
    #   {                                           # how the worker should be started
    #     :poolboy,                                 # Module
    #     :start_link,                              # Function
    #     [                                         # Arguments
    #       [
    #         name: {:local, :my_pool},
    #         worker_module: PoolboyExample2.Worker,
    #         size: 5,
    #         max_overflow: 0
    #       ],
    #       []
    #     ]
    #   },
    #   :permanent,                                 # when a terminated child process should be restarted
    #   5000,                                       # how a child process should be terminated.
    #   :worker,                                    # worker or supervisor
    #   [:poolboy]                                  # modules we depend on
    # }

    children = [
      :poolboy.child_spec(:hello_pool, pool_options, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
