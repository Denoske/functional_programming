-module(main).
-export([find_triplet/0, product/3]).

find_triplet() ->
    Sum = 1000,
    lists:foreach(
        fun(A) ->
            lists:foreach(
                fun(B) ->
                    C = Sum - A - B,
                    case {A, B, C} of
                        {A, B, C} when A < B, B < C, A > 0, B > 0, C > 0 ->
                            if 
                                A * A + B * B == C * C -> 
                                    io:format("a: ~p, b: ~p, c: ~p, sum: ~p, product abc: ~p~n", 
                                              [A, B, C, A+B+C , product(A, B, C)]);
                                true -> ok
                            end;
                        _ -> ok
                    end
                end,
                lists:seq(A + 1, Sum - A - 1)
            )
        end,
        lists:seq(1, Sum div 3) %% A должно быть меньше Sum/3
    ).

product(A, B, C) ->
    A * B * C.

