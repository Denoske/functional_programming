-module(lab2_app).
-include_lib("src/sc_set.erl").
-include_lib("eunit/include/eunit.hrl").
-include_lib("proper/include/proper.hrl").

create_set_from_range(Range) ->
    lists:foldl(fun(N, Acc) -> sc_set:put(Acc, N) end, sc_set:new(), Range).

scset() ->
    ?LET(Len, range(3, 10),
         lists:foldl(fun(N, Acc) -> sc_set:put(Acc, N) end, sc_set:new(), lists:sublist(integer(), Len))).

creates_empty_test() ->
    ?assertEqual(#{}, sc_set:new()).

put_test_() ->
    [?_test(begin
                Value = 5,
                Set = sc_set:new(),
                ?assertEqual(#{erlang:phash2(5) => [5]}, sc_set:put(Set, Value))
            end),
     ?_property(
        ?FORALL(Value, term(),
                begin
                    Set = sc_set:put(sc_set:new(), Value),
                    sc_set:put(Set, Value) =:= Set
                end))
    ].

delete_test_() ->
    [?_test(begin
                Value = 5,
                Set = sc_set:put(sc_set:new(), Value),
                ?assertEqual(#{}, sc_set:delete(Set, Value))
            end),
     ?_property(
        ?FORALL(Value, term(),
                begin
                    Set = sc_set:new(),
                    sc_set:delete(Set, Value) =:= #{}
                end))
    ].

member_test_() ->
    [?_test(begin
                Range = lists:seq(0, 20),
                S = create_set_from_range(Range),
                ?assert(sc_set:member(S, 8))
            end),
     ?_test(begin
                S = create_set_from_range(lists:seq(0, 20)),
                ?assertNot(sc_set:member(S, -1)),
                ?assertNot(sc_set:member(S, 21))
            end)
    ].

contains_all_test_() ->
    [?_test(begin
                S = create_set_from_range(lists:seq(0, 20)),
                SS = create_set_from_range(lists:seq(3, 7)),
                ?assert(sc_set:contains_all(S, SS))
            end),
     ?_test(begin
                S = create_set_from_range(lists:seq(0, 20)),
                SS = create_set_from_range(lists:seq(10, 30)),
                ?assertNot(sc_set:contains_all(S, SS))
            end),
     ?_property(
        ?FORALL(S, scset(),
                begin
                    SS = sc_set:new(),
                    sc_set:contains_all(S, SS)
                end))
    ].

equal_test_() ->
    [?_test(begin
                S1 = create_set_from_range(lists:seq(0, 20)),
                S2 = create_set_from_range(lists:seq(0, 20)),
                ?assert(sc_set:equal(S1, S2))
            end),
     ?_test(begin
                S1 = create_set_from_range(lists:seq(0, 20)),
                S2 = create_set_from_range(lists:seq(20, 0, -1)),
                ?assert(sc_set:equal(S1, S2))
            end),
     ?_test(begin
                S1 = sc_set:new(),
                S2 = sc_set:new(),
                ?assert(sc_set:equal(S1, S2))
            end),
     ?_test(begin
                S1 = create_set_from_range(lists:seq(0, 20)),
                S2 = create_set_from_range(lists:seq(10, 30)),
                ?assertNot(sc_set:equal(S1, S2))
            end)
    ].

filter_test() ->
    S = create_set_from_range(lists:seq(0, 20)),
    ?assert(sc_set:equal(
        sc_set:filter(S, fun(N) -> N rem 2 =:= 0 end),
        create_set_from_range(lists:seq(0, 20, 2))
    )).

map_test() ->
    S = create_set_from_range(lists:seq(0, 20)),
    ?assert(sc_set:equal(
        sc_set:map(S, fun(N) -> N + 10 end),
        create_set_from_range(lists:seq(10, 30))
    )).

reduce_test() ->
    S = create_set_from_range(lists:seq(0, 20)),
    ?assertEqual(210, sc_set:reduce(S, 0, fun(N, Acc) -> Acc + N end)).

union_test_() ->
    [?_test(begin
                S1 = create_set_from_range(lists:seq(0, 10)),
                S2 = create_set_from_range(lists:seq(11, 20)),
                ?assert(sc_set:equal(sc_set:union(S1, S2), create_set_from_range(lists:seq(0, 20))))
            end),
     ?_property(
        ?FORALL({A, B}, {scset(), #{}},
                sc_set:equal(sc_set:union(A, B), A)))
    ].

monoid_test_() ->
    [?_property(
        ?FORALL({A, B, C}, {scset(), scset(), scset()},
                sc_set:equal(
                    sc_set:union(sc_set:union(A, B), C),
                    sc_set:union(A, sc_set:union(B, C))
                ))),
     ?_property(
        ?FORALL(A, scset(),
                begin
                    E = sc_set:new(),
                    sc_set:equal(sc_set:union(E, A), A) andalso
                    sc_set:equal(sc_set:union(A, E), A)
                end))
    ].

