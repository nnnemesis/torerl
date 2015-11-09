-module(torrent_info_tests).
-compile(export_all).

run_all_tests()->
	test_torrent_info1(),
	test_torrent_info2(),
	test_info_sha1_1(),
	ok.

test_torrent_info1()->
	{ok, Binary} = file:read_file("zaplutavshie.torrent"),
	[Dict] = bencoder:decode(Binary),
	<<"udp://bt.rutor.org:2710">> = torrent_info:get_announce(Dict),
	[[<<"udp://bt.rutor.org:2710">>]
		, [<<"udp://opentor.org:2710">>]
		, [<<"http://retracker.local/announce">>]
		, [<<"udp://tracker.openbittorrent.com:80">>]
		, [<<"udp://open.demonii.com:1337">>]
		, [<<"udp://tracker.leechers-paradise.org:6969">>]
		, [<<"udp://tracker.coppersurfer.tk:6969">>]
		, [<<"udp://tracker.blackunicorn.xyz:6969">>]
		, [<<"http://pubt.net:2710/announce">>]] = torrent_info:get_announce_list(Dict).
	
test_torrent_info2()->
	{ok, Binary} = file:read_file("zaplutavshie.torrent"),
	[Dict] = bencoder:decode(Binary),
	[[<<"length">>, 880249, <<"path">>, 
		[<<208,154,209,128,208,176,209,131,209,135,
                                46,32,208,161,208,190,209,129,208,189,209,
                                139,46,32,208,151,208,176,208,191,208,187,
                                209,131,209,130,208,176,208,178,209,136,
                                208,184,208,181,46,101,112,117,98>>]]
	,[<<"length">>, 1265619, <<"path">>,
		[<<208,154,209,128,208,176,209,131,209,135,
                                46,32,208,161,208,190,209,129,208,189,
                                209,139,46,32,208,151,208,176,208,191,
                                208,187,209,131,209,130,208,176,208,178,
                                209,136,208,184,208,181,46,102,98,50>>]]] = torrent_info:get_files(Dict).
								
test_info_sha1_1()->
	{ok, Binary} = file:read_file("zaplutavshie.torrent"),
	[Dict] = bencoder:decode(Binary),
	Hash = torrent_info:get_info_sha1(Dict),
	HexHash = bencode_utils:binary_to_hex_binary(Hash),
	%io:format("Hash ~p~n",[HexHash]),
	<<"2b8919d776b0e5130647bc73dbb87ff58271eb12">> = HexHash,
	<<43,137,25,215,118,176,229,19,6,71,188,115,219,184,127,245,130,113,235,18>> = Hash.
	