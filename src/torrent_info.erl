-module(torrent_info).
-export([get_announce/1]).

%%export
get_announce(Dict) ->
	bencode_utils:dict_find_by_key(<<"announce">>, Dict).	
%%export
	
%%internal

	
