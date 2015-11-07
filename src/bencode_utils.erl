-module(bencode_utils).
-export([dict_find_by_key/2, make_bytestring/1, make_bytestring/2
			, get_simple_presintation/1]).

%%ONLY INTERNAL USE
get_simple_presintation({bytestring, _Size, Content})->
	Content;
get_simple_presintation({number, Value})->
	Value;
get_simple_presintation({list, Content})->
	get_list_simple_presintation(Content, []);
get_simple_presintation({dict, Content})->
	get_list_simple_presintation(Content, []).

get_list_simple_presintation([], Acc)->
	lists:reverse(Acc);
get_list_simple_presintation([H|T], Acc)->
	get_list_simple_presintation(T, [get_simple_presintation(H)|Acc]).

%%FIND
dict_find_by_key(Key, {dict, Content}) when is_bitstring(Key)->
	dict_find_by_key(make_bytestring(Key),Content);
dict_find_by_key(_Key, [])->
	not_found;
dict_find_by_key(K, [K|[Value|_T]])->
	{ok, get_simple_presintation(Value)};
dict_find_by_key(Key, [_H|[_V|T]])->
	dict_find_by_key(Key, T).
%%FIND

%%MAKE
%%ONLY INTERNAL USE
make_bytestring(Content) when is_bitstring(Content) ->
	{bytestring,byte_size(Content),Content}.
make_bytestring(Content, ByteSize) when is_bitstring(Content) ->
	{bytestring,ByteSize,Content}.
%%MAKE


