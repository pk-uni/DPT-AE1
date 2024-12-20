-module(test_parallel).
-export([run_DS1/0, run_DS2/0, run_DS3/0]).

-define(DEFAULT_WORKERS, 4).
-define(NUM_RUNS, 5).

run_DS1() ->
    run_parallel_test("DS1", 1, 15000, [1, 2, 4, 8, 12, 16, 24, 32, 48, 64]).

run_DS2() ->
    run_parallel_test("DS2", 1, 30000, [1, 2, 4, 8, 12, 16, 24, 32, 48, 64]).

run_DS3() ->
    run_parallel_test("DS3", 1, 60000, [2, 4, 8, 12, 16, 24, 32, 48, 64]).

run_parallel_test(Dataset, Lower, Upper, WorkerCounts) ->
    % io:format("Running parallel tests for Dataset ~p (range: ~p to ~p)~n", [Dataset, Lower, Upper]),

    lists:foreach(
        fun(NumWorkers) ->
            lists:foreach(
                fun(_) ->
                    {runtime, T, Result} = parallel:start(Lower, Upper, NumWorkers),
                    io:format("~s,parallel,~.6f,~p~n", [Dataset, T, NumWorkers]),
                    Result
                end,
                lists:seq(1, ?NUM_RUNS)
            )
        end,
        WorkerCounts
    ).
