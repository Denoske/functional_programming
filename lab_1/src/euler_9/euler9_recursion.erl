-module(euler9_recursion).
-export([find_triplet/0]).

-include_lib("eunit/include/eunit.hrl").

find_ints(A, Sum)
    when Sum * (Sum - 2 * A) rem (2 * Sum - 2 * A) == 0,
         A < Sum * (Sum - 2 * A) / (2 * Sum - 2 * A) ->
    B = Sum * (Sum - 2 * A) div (2 * Sum - 2 * A),
    {A, B, Sum - A - B};
find_ints(A, Sum) ->
    {NewA, B, C} = find_ints(A + 1, Sum),
    {NewA, B, C}.

find_triplet() ->
    {A, B, C} = find_ints(1, 1000),
    A * B * C.
