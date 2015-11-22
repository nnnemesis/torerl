-module(torrent_info).
-export([get_announce/1, get_announce_list/1, get_files/1
	,get_info_sha1/1, get_total_length/1]).

%%export
get_announce(Dict) ->
	{ok, Value} = bencode_utils:dict_find_by_key(<<"announce">>, Dict),
	bencode_utils:get_simple_presintation(Value).
	
get_announce_list(Dict) ->
	{ok, Value} = bencode_utils:dict_find_by_key(<<"announce-list">>, Dict),
	bencode_utils:get_simple_presintation(Value).

get_files(Dict) ->
	{ok, InfoDict} = bencode_utils:dict_find_by_key(<<"info">>, Dict),
	{ok, FileList} = bencode_utils:dict_find_by_key(<<"files">>, InfoDict),
	bencode_utils:get_simple_presintation(FileList).

get_info_sha1(Dict)->
	{ok, InfoDict} = bencode_utils:dict_find_by_key(<<"info">>, Dict),
	Binary = bencoder:encode(InfoDict),
	_Hash = crypto:hash(sha, Binary).

get_total_length(Dict)->
	{ok, InfoDict} = bencode_utils:dict_find_by_key(<<"info">>, Dict),
	{ok, FileList} = bencode_utils:dict_find_by_key(<<"files">>, InfoDict),
	%io:format("FileList ~p~n", [FileList]),
	get_files_length(
		bencode_utils:get_simple_presintation_non_rec(FileList), 0).
	
get_files_length([FileDict|T], Acc)->
	%io:format("FileDict ~p~n", [FileDict]),
	{ok, Length} = bencode_utils:dict_find_by_key(<<"length">>, FileDict),
	%io:format("Length ~p~n", [Length]),
	get_files_length(T, Acc + 
		bencode_utils:get_simple_presintation_non_rec(Length));
get_files_length([], Acc)->
	Acc.
	
%%export
	
%%internal

	
