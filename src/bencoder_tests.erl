-module(bencoder_tests).
-compile(export_all).

%% TESTS
test_numbers()->
	[] = bencoder:decode(<<>>),
	[{number, 0}] = bencoder:decode(<<"i0e">>),
	[{number, 1}] = bencoder:decode(<<"i1e">>),
	[{number, 123}] = bencoder:decode(<<"i123e">>),
	[{number, -123}] = bencoder:decode(<<"i-123e">>),
	[{number, 56687}] = bencoder:decode(<<"i56687e">>),
	[{number, 56687}, {number, -123}] = bencoder:decode(<<"i56687ei-123e">>).
	
test_bytestrings()->
	[] = bencoder:decode(<<>>),
	[{bytestring, 4, <<"spam">>}] = bencoder:decode(<<"4:spam">>),
	[{bytestring, 0, <<>>}] = bencoder:decode(<<"0:">>).
	
test_lists()->
	[] = bencoder:decode(<<>>),
	[{list,[{number, 1}]}] = bencoder:decode(<<"li1ee">>),
	[{list,[{number, 1},{number, 123}]}] = bencoder:decode(<<"li1ei123ee">>).
	
test_dicts() ->
	[] = bencoder:decode(<<>>),
	[{dict,[{bytestring, 3, <<"bar">>}, {bytestring, 4, <<"spam">>}
		, {bytestring, 3, <<"foo">>}, {number, 42}]}] = bencoder:decode(<<"d3:bar4:spam3:fooi42ee">>).
	
test_all()->
	[] = bencoder:decode(<<>>),
	[{number, 123}, {bytestring, 4, <<"spam">>}] = bencoder:decode(<<"i123e4:spam">>).
	
test_on_file1()->
	{ok, Binary} = file:read_file("zaplutavshie.torrent"),
	Res = bencoder:decode(Binary),
	io:format("Res ~n~p~n", [Res]).
	
test_on_file2()->
	{ok, Binary} = file:read_file("agents.torrent"),
	Res = bencoder:decode(Binary),
	io:format("Res ~n~p~n", [Res]).
	
%% TESTS