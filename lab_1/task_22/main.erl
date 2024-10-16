-module(main).
-export([main/1]).

main(File) ->
    {ok, Binary} = file:read_file(File),
    NamesString = binary_to_list(Binary),
    NamesList = string:tokens(NamesString, "\","),
    SortedNames = lists:sort(NamesList),
    ScoreTotal = calculate_total_score(SortedNames, 1),
    ScoreTotal.

calculate_total_score([], _) -> 0;
calculate_total_score([Name | Rest], Index) ->
    NameScore = calculate_name_score(Name),
    Points = Index * NameScore,
    Points + calculate_total_score(Rest, Index + 1).

calculate_name_score(Name) ->
    lists:sum([char_to_int(C) || C <- Name]).


char_to_int(C) ->
    case C of
        $A -> 1; $B -> 2; $C -> 3; $D -> 4; $E -> 5;
        $F -> 6; $G -> 7; $H -> 8; $I -> 9; $J -> 10;
        $K -> 11; $L -> 12; $M -> 13; $N -> 14; $O -> 15;
        $P -> 16; $Q -> 17; $R -> 18; $S -> 19; $T -> 20;
        $U -> 21; $V -> 22; $W -> 23; $X -> 24; $Y -> 25;
        $Z -> 26;
        _ -> 0
    end.
