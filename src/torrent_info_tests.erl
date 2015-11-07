-module(torrent_info_tests).
-compile(export_all).

run_all_tests()->
	test_torrent_info1(),
	ok.

test_torrent_info1()->
	{ok, Binary} = file:read_file("zaplutavshie.torrent"),
	[Dict] = bencoder:decode(Binary),
	{ok, <<"udp://bt.rutor.org:2710">>} = torrent_info:get_announce(Dict).