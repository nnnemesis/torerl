-module(bencoder_tests).
-compile(export_all).

%% TESTS
run_all_tests()->
	test_numbers(),
	test_bytestrings(),
	test_lists(),
	test_dicts(),
	test_all(),
	test_on_file1(),
	test_on_file2(),
	test_number_encode(),
	test_bytestring_encode(),
	test_list_encode(),
	test_dict_encode(),
	ok.

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
	%io:format("Res ~n~p~n", [Res]),
	ok.
	
test_on_file2()->
	{ok, Binary} = file:read_file("agents.torrent"),
	Res = bencoder:decode(Binary),
	%io:format("Res ~n~p~n", [Res]),
	ok.
	
%% TESTS

test_number_encode()->
	<<"i0e">> = bencoder:encode({number, 0}),
	<<"i123e">> = bencoder:encode({number, 123}),
	<<"i-123e">> = bencoder:encode({number, -123}).

test_bytestring_encode()->
	<<"4:spam">> = bencoder:encode({bytestring, 4, <<"spam">>}).
	
test_list_encode()->
	<<"li0ei123ee">> = bencoder:encode({list, [{number, 0}, {number, 123}]}).
	
test_dict_encode()->
	<<"d4:spami123ee">> = bencoder:encode({dict, [{bytestring, 4, <<"spam">>}, {number, 123}]}).
