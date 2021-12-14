%%%-----------------------------------------------------------------------------
%%% @title day14
%%% @doc
%%%
%%% @author bocdev
%%% @version 0.0.1
%%% @end
%%%-----------------------------------------------------------------------------

-module(day14).
-author(bocdev).

%%%=============================================================================
%%% Exports and Definitions
%%%=============================================================================

-export([both/0]).

%%%=============================================================================
%%% API
%%%=============================================================================

both() ->
    part_one(),
    part_two().

part_one() ->
    {ok, BinData} = file:read_file("input.txt"),
    {Template, Mapping} = parse_file(BinData),
    FinalTemplate = lists:foldl(
        fun(_Num, UpdatedTemplate) ->
            do_step(UpdatedTemplate, Mapping, <<>>)
        end,
        Template,
        lists:seq(1, 10)),
    CountMap = count_characters(FinalTemplate, maps:new()),
    PartOneAnswer = calc_most_minus_least(CountMap),
    io:format("Part 1: ~p~n", [PartOneAnswer]).

part_two() ->
    {ok, BinData} = file:read_file("input.txt"),
    {{TemplateMap, Mapping}, LastCharacter} = parse_file_map(BinData),

    FinalTemplateMap = lists:foldl(
        fun(_Num, UpdatedTemplateMap) ->
            do_map_step(UpdatedTemplateMap, Mapping)
        end,
        TemplateMap,
        lists:seq(1, 40)),

    PartTwoAnswer = calc_most_minus_least_part_two(FinalTemplateMap, LastCharacter),

    io:format("Part 2: ~p~n", [PartTwoAnswer]).

%%%===================================================================
%%% Internal functions
%%%===================================================================

parse_file(InputBin) ->
    [Template, MapData] = binary:split(InputBin, <<"\r\n\r\n">>, [global]),
    {Template, create_map(MapData)}.

create_map(MapData) ->
    lists:foldl(
        fun(Entry, Map) ->
            [Key, Val] = binary:split(Entry, <<" -> ">>, [global]),
            maps:put(Key, Val, Map)
        end,
        maps:new(),
        binary:split(MapData, <<"\r\n">>, [global])).

do_step(<<First, Second, Rest/binary>>, Mapping, Acc) ->
    FirstBin = list_to_binary([First]),
    SecondBin = list_to_binary([Second]),
    AdditionalCharacter = maps:get(<<FirstBin/binary, SecondBin/binary>>, Mapping),
    do_step(<<SecondBin/binary, Rest/binary>>, Mapping, <<Acc/binary, FirstBin/binary, AdditionalCharacter/binary>>);
do_step(Last, _, Acc) -> 
    <<Acc/binary, Last/binary>>.

count_characters(<<>>, CountMap) ->
    CountMap;
count_characters(<<First, Rest/binary>>, CountMap) ->
    FirstBin = list_to_binary([First]),
    count_characters(Rest, 
        case maps:find(FirstBin, CountMap) of
            {ok, Val} -> maps:put(FirstBin, Val + 1, CountMap);
            error -> maps:put(FirstBin, 1, CountMap)
        end).

calc_most_minus_least(CountMap) ->
    [First | Rest] = lists:sort(maps:values(CountMap)),
    lists:last(Rest) - First.

parse_file_map(InputBin) ->
    [Template, MapData] = binary:split(InputBin, <<"\r\n\r\n">>, [global]),
    {create_maps(Template, MapData), binary:last(Template)}.

create_maps(Template, MapData) ->
    {RetScoreMap, RetMappingMap} = lists:foldl(
        fun(Entry, {ScoreMap, MappingMap}) ->
            [Key, Val] = binary:split(Entry, <<" -> ">>, [global]),
            {maps:put(Key, 0, ScoreMap), maps:put(Key, Val, MappingMap)}
        end,
        {maps:new(), maps:new()},
        binary:split(MapData, <<"\r\n">>, [global])),
    {add_template_to_map(Template, RetScoreMap), RetMappingMap}.

add_template_to_map(<<First, Second, Rest/binary>>, MapData) ->
    FirstBin = list_to_binary([First]),
    SecondBin = list_to_binary([Second]),
    Key = <<FirstBin/binary, SecondBin/binary>>,
    add_template_to_map(<<SecondBin/binary, Rest/binary>>, case maps:find(Key, MapData) of
        {ok, Val} -> maps:put(Key, Val + 1, MapData);
        error -> maps:put(Key, 1, MapData)
    end);
add_template_to_map(_Last, MapData) ->
    MapData.

do_map_step(TemplateMap, Mapping) ->
    maps:fold(
        fun(Key, Val, AccMap) -> 
            NewCharacter = maps:get(Key, Mapping),
            <<FirstCharacter, SecondCharacter>> = Key,
            FirstBin = list_to_binary([FirstCharacter]),
            SecondBin = list_to_binary([SecondCharacter]),
            add_to_map(<<NewCharacter/binary, SecondBin/binary>>, <<FirstBin/binary, NewCharacter/binary>>, Val, AccMap)
        end,
        maps:new(),    
        TemplateMap).

add_to_map(Key1, Key2, Amount, Map) ->
    UpdatedMap = case maps:find(Key1, Map) of
        {ok, Val1} -> maps:put(Key1, Val1 + Amount, Map);
        error -> maps:put(Key1, Amount, Map)
    end,
    case maps:find(Key2, UpdatedMap) of
        {ok, Val2} -> maps:put(Key2, Val2 + Amount, UpdatedMap);
        error -> maps:put(Key2, Amount, UpdatedMap)
    end.

calc_most_minus_least_part_two(CountMap, LastCharacter) ->
    % Get list of characters
    FinalMap = maps:fold(fun(Key, Value, AccMap) ->
            <<First, _>> = Key,
            FirstBin = list_to_binary([First]),
            case maps:find(FirstBin, AccMap) of
                {ok, Val} -> maps:put(FirstBin, Val + Value, AccMap);
                error -> maps:put(FirstBin, Value, AccMap)
            end
        end, 
        maps:put(<<LastCharacter>>, 1, maps:new()),
        CountMap),
        
    calc_most_minus_least(FinalMap).