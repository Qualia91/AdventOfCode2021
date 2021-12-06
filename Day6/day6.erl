%%%-----------------------------------------------------------------------------
%%% @title day6
%%% @doc
%%%
%%% @author bocdev
%%% @version 0.0.1
%%% @end
%%%-----------------------------------------------------------------------------

-module(day6).
-author(bocdev).

%%%=============================================================================
%%% Exports and Definitions
%%%=============================================================================

-define(SERVER, ?MODULE).

-export([both/0, part_one/0, part_two/0]).

-define(COMMA, 44).

%%%=============================================================================
%%% API
%%%=============================================================================

both() ->
    part_one(),
    part_two().

part_one() ->
    {ok, BinData} = file:read_file("input.txt"),
    Return = iterate_day(convert_to_int_list(BinData), 80),
    io:format("Part 1 Count: ~p~n", [length(Return)]).

part_two() ->
    {ok, BinData} = file:read_file("input.txt"),
    GrowQueue = convert_to_int_queue(BinData),
    BirthQueue = queue:in(0, queue:in(0, queue:new())),
    
    FinalQueue = iterate_day(BirthQueue, GrowQueue, 256),
    Sum = lists:foldl(fun(Val, SumAcc) ->
        SumAcc + Val
    end, 0, queue:to_list(FinalQueue)),
    io:format("Part 2 Count: ~p~n", [Sum]).

%%%===================================================================
%%% Internal functions
%%%===================================================================

convert_to_int_queue(BinData) ->
    Dict = convert_to_int_dict(lists:sort(binary_to_list(BinData)), dict:new()),

    lists:foldl(
        fun(Elem, AccQueue) ->
            case dict:find(Elem, Dict) of
                {ok, Val} -> queue:in(Val, AccQueue);
                _ -> queue:in(0, AccQueue)
            end
        end,
        queue:new(),
        lists:seq(0, 6)).

convert_to_int_dict([], Dict) ->
    Dict;
convert_to_int_dict([Hd | Tail], Dict) ->
    convert_to_int_dict(Tail, case Hd of
        ?COMMA -> Dict;
        Other -> 
            NewNumber = Other - 48,
            case dict:find(NewNumber, Dict) of
                {ok, Val} ->
                    dict:store(NewNumber, Val + 1, Dict);
                error ->
                    dict:store(NewNumber, 1, Dict)
            end
    end).


convert_to_int_list(BinData) ->
    convert_to_int_list(binary_to_list(BinData), []).

convert_to_int_list([], Acc) ->
    Acc;
convert_to_int_list([Hd | Tail], Acc) ->
    convert_to_int_list(Tail, case Hd of
        ?COMMA -> Acc;
        Other -> 
            [(Other - 48) | Acc]
    end).

iterate_over_binary([], Acc) ->
    Acc;
iterate_over_binary([Hd | Tail], Acc) ->
    UpdatedAcc = case Hd of
        ?COMMA -> Acc;
        Other -> 
            case Other of
                0 -> [8 | [6 | Acc]];
                NotZero -> 
                    Number = NotZero - 1,
                    [Number | Acc]
            end
    end,
    iterate_over_binary(Tail, UpdatedAcc).

iterate_day(List, 0) ->
    List;
iterate_day(List, Days) ->
    UpdatedList = iterate_over_binary(List, []),
    iterate_day(UpdatedList, Days - 1).

iterate_day(BirthQueue, GrowQueue, 0) ->
    merge_queues(queue:out(BirthQueue), GrowQueue);
iterate_day(BirthQueue, GrowQueue, Days) ->
    {BirthHead, UpdatedBirthQueue} = queue:out(BirthQueue),
    {GrowHead, UpdatedGrowQueue} = queue:out(GrowQueue),

    AddToGrowQueue = case BirthHead of
        {value, BirthHeadVal} -> BirthHeadVal;
        _ -> 0
    end,

    AddToBirthQueue = case GrowHead of
        {value, GrowHeadVal} -> GrowHeadVal;
        _ -> 0
    end,

    iterate_day(queue:in(AddToBirthQueue, UpdatedBirthQueue), queue:in(AddToBirthQueue + AddToGrowQueue, UpdatedGrowQueue), Days - 1).


merge_queues({{value, Val}, BirthQueue}, GrowQueue) ->
    merge_queues(queue:out(BirthQueue), queue:in(Val, GrowQueue));
merge_queues({empty, _BirthQueue}, GrowQueue) ->
    GrowQueue.
