# ElixirCoin

Let's build a small distributed system to mine a new cryptocurrency and become millionaires in **ElixirCoins**!

> An ElixirCoin is a `{secret_string, positive_integer}` pair for which the MD5 digest of the concatenation of the secret string with the given integer is a hash whose hexadecimal representation starts with at least 5 consecutive zeroes.

For instance:

- `{"foo", 123}` is **not** an ElixirCoin because the MD5 hash of `foo123` is `ef238ea00a26528de40ff231e5a97f50`
- `{"Serun+u", 1}` is a **valid ElixirCoin** because the MD5 hash of `Serun+u1` is `00000011f4de73238f12fb2c57d5dc56`

## Goal

Each team must implement a **miner worker process** which will connect to the server and mine ElixirCoins. The server maintains a **leaderboard**: the most efficient miners will be rewarded a percentage of the wallet's worth! 😀

## Server

The server is in charge of:

- keeping track of the miners and their performance
- distributing work to the miners
- keeping track of the mined coins
- keeping track of the workload and progress

The distributed unit of work is either:

- a single integer to mine
- a pair `{i, j}` of integers defining an inclusive positive integer range [i,j] to mine

The type and size of the unit workload (workload) **may change at any time**, your worker must be able to deal with it.

## Workflow

The flow for miners is fairly simple:

1. the miner registers to the server with a unique name
2. it will receive the secret to be used as well as a first unit of work
3. for each ElixirCoin found, the miner sends a message to the server
4. when the miner has completed its unit of work, it notifies the server to receive more work

## Client-Server Protocol

The following messages can be sent and received using the **public API** of the `ElixirCoin.Server` module.

### Miner Registration

#### Request

```Elixir
{:hello, "<miner-name>"}
```

#### Responses

```Elixir
{:ok, secret, integer}
{:ok, secret, {integer, integer}}
{:error, message}
```

### Coin Found

#### Request

```Elixir
{:coin, "<miner-name>", integer}
```

#### Responses

```Elixir
{:ok, count}
{:error, message}
```

`count` is the total number of coins the miner has found so far

### Work Completed

#### Request

```Elixir
{:done, "<miner-name>"}
```

#### Responses

```Elixir
{:ok, integer}
{:ok, {integer, integer}}
{:error, message}
```

## Running Your Worker

You will receive two important piece of information to connect to the server:

* the server node name, e.g. `:"server@192.168.0.13"`
* the cluster cookie

To start the VM and join the cluster, use:

`$ elixir --name "my-node-name" --cookie "some-cookie" my_worker.exs`

Before you send any message to the server, make sure you connect to the server node:

```Elixir
Node.connect(:"server@192.168.0.13")
# => true
```

You can then use the `ElixirCoin.Server` public API using the PID `{ElixirCoin.Server, server_name}`, e.g. `{ElixirCoin.Server, :"server@192.168.0.13"}`.

## Credits

Freely inspired from the day 4 problem of the fantastic [Advent of Code](http://adventofcode.com) 2015.
