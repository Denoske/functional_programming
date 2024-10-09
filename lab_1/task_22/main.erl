-module(main).
-export([main/0,get_names/0,score/1,char_to_int/1]).

main() ->
  Names = get_names(),
  lists:sum([score(Name) * (I + 1) || {I, Name} <- lists:zip(lists:seq(1, length(Names)), Names)]).

get_names() ->
  File = "names.txt",
  {ok, Data} = file:read_file(File),
  [Name || Name <- string:split(binary_to_list(Data), ",")].

score(Name) ->
  lists:sum([char_to_int(C) - 96 || C <- Name]).

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
