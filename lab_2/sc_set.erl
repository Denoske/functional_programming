-module(sc_set).
-export([new/0, put/2, delete/2, filter/2, map/2, reduce/3, union/2, member/2, size/1, contains_all/2, equal/2]).

new() ->
    #{ }.

put(ScSet, Item) ->
    Key = hash_key(Item),
    Entries = maps:get(Key, ScSet, []),
    case lists:member(Item, Entries) of
        true -> ScSet;
        false -> maps:put(Key, [Item | Entries], ScSet)
    end.

delete(ScSet, Item) ->
    Key = hash_key(Item),
    Entries = maps:get(Key, ScSet, []),
    NewEntries = lists:filter(fun(V) -> V =/= Item end, Entries),
    case NewEntries of
        [] -> maps:remove(Key, ScSet);
        _ -> maps:put(Key, NewEntries, ScSet)
    end.

filter(ScSet, Fun) ->
    ScSet1 = maps:map(fun(K, V) -> {K, lists:filter(Fun, V)} end, ScSet),
    maps:filter(fun(_, V) -> V =/= [] end, ScSet1).

map(ScSet, Fun) ->
    Entries = lists:flatmap(fun({_, Entries}) -> Entries end, maps:to_list(ScSet)),
    Mapped = lists:map(Fun, Entries),
    lists:foldl(fun(Item, Acc) -> sc_set:put(Acc, Item) end, new(), Mapped).

reduce(ScSet, Acc, Fun) ->
    lists:foldl(fun({_, Entries}, Acc1) -> lists:foldl(Fun, Acc1, Entries) end, Acc, maps:to_list(ScSet)).

union(ScSet, Other) ->
    lists:foldl(fun({_, V}, Acc) -> lists:foldl(fun(Item, Acc1) -> sc_set:put(Acc1, Item) end, Acc, V) end, ScSet, maps:to_list(Other)).

member(ScSet, Value) ->
    Key = hash_key(Value),
    Entries = maps:get(Key, ScSet, []),
    lists:member(Value, Entries).

size(ScSet) ->
    reduce(ScSet, 0, fun(_, Acc) -> Acc + 1 end).

contains_all(ScSet, Other) ->
    reduce(Other, true, fun(V, Acc) -> Acc and member(ScSet, V) end).

equal(ScSet, Other) ->
    contains_all(ScSet, Other) and contains_all(Other, ScSet).

hash_key(Key) ->
    erlang:phash2(Key).

