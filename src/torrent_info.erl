-module(torrent_info).
-export([get_announce/1]).

%%export
get_announce(Dict) ->
	bencoder:dict_find_by_key(<<"announce">>, Dict).
	
test_torrent_info1()->
	{ok, Binary} = file:read_file("zaplutavshie.torrent"),
	[Dict] = bencoder:decode(Binary).
	
%%export
	
%%internal

	
