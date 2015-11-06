-module(bencode_utils).
-export([dict_find_by_key/2]).

%%FIND
dict_find_by_key(Key, {dict, Content}) when is_bitstring(Key)->
	dict_find_by_key(bencode:make_bytestring(Key),Content);
dict_find_by_key(_Key, [])->
	not_found;
dict_find_by_key(K, [K|[Value|_T]])->
	{ok, Value};
dict_find_by_key(Key, [_H|[_V|T]])->
	dict_find_by_key(Key, T).
%%FIND

test_dict_find()->
	Dict = {dict,
				[{bytestring,8,<<"announce">>},
				{bytestring,23,<<"udp://bt.rutor.org:2710">>}]
			},
	{ok, {bytestring,23,<<"udp://bt.rutor.org:2710">>}} = bencoder:dict_find_by_key(<<"announce">>, Dict).