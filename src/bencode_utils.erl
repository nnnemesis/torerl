-module(bencode_utils).
-export([dict_find_by_key/2, make_bytestring/1, make_bytestring/2
			, get_simple_presintation/1, reverse_binary/1, binary_to_hex_binary/1
			, get_simple_presintation_non_rec/1]).

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

get_simple_presintation_non_rec({list, Content})->
	Content;
get_simple_presintation_non_rec({bytestring, _Size, Content})->
	Content;
get_simple_presintation_non_rec({number, Value})->
	Value;
get_simple_presintation_non_rec({dict, Content})->
	Content;
get_simple_presintation_non_rec(_Any)->
	throw(get_simple_presintation_non_rec_error).
	
%%FIND
dict_find_by_key(Key, {dict, Content}) when is_binary(Key)->
	dict_find_by_key(make_bytestring(Key),Content);
dict_find_by_key(_Key, [])->
	not_found;
dict_find_by_key(K, [K|[Value|_T]])->
	{ok, Value};
dict_find_by_key(Key, [_H|[_V|T]])->
	dict_find_by_key(Key, T).
%%FIND

%%MAKE
%%ONLY INTERNAL USE
make_bytestring(Content) when is_binary(Content) ->
	{bytestring,byte_size(Content),Content}.
make_bytestring(Content, ByteSize) when is_binary(Content) ->
	{bytestring,ByteSize,Content}.
%%MAKE

%%REVERSE
reverse_binary(Binary) when is_binary(Binary) ->
	S = bit_size(Binary),  
	<<X:S/integer-little>>=Binary, 
	<<X:S/integer-big>>.
%%REVERSE
	
%%BINARY TO HEX BINARY STRING
binary_to_hex_binary(Bin) when is_binary(Bin) ->
    << <<(hex_symbol(H)),(hex_symbol(L))>> || <<H:4,L:4>> <= Bin >>.

hex_symbol(C) when C < 10 -> $0 + C;
hex_symbol(C) -> $a + C - 10.
%%BINARY TO HEX STRING