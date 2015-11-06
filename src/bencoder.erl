-module(bencoder).
-export([decode/1, test_numbers/0
	,test_bytestrings/0, test_all/0, test_lists/0
	,test_dicts/0]).
	
%%EXPORT
decode(FileData) when is_bitstring(FileData) ->
	{Terms, <<>>} = dec(FileData, []),
	lists:reverse(Terms).
%%EXPORT
	
%%INTERNAL
dec(<<>>, Acc)->
	{Acc, <<>>};
dec(<<"e", Rest/binary>>, Acc)->
	{Acc, Rest, e_found};
dec(<<"i0e", Rest/binary>>, Acc)->
	dec(Rest, [{number,0}|Acc]);
dec(<<"i", Rest/binary>>, Acc)->
	{Number, Rest1} = dec_number(Rest, <<>>),
	dec(Rest1, [Number|Acc]);
dec(<<"l", Rest/binary>>, Acc)->
	case dec(Rest, []) of
		{ListContent, Rest1, e_found} -> 
			dec(Rest1, [{list, lists:reverse(ListContent)}|Acc]);
		_Any ->
			throw(list_decode_error)
	end;
dec(<<"d", Rest/binary>>, Acc)->
	case dec(Rest, []) of
		{DictContent, Rest1, e_found} ->
			dec(Rest1, [{dict, lists:reverse(DictContent)}|Acc]);
		_Any ->
			throw(dict_decode_error)
	end;
dec(Rest, Acc)->
	{Token, Rest1} = dec_bytestring(Rest),
	dec(Rest1, [Token|Acc]).
	
dec_bytestring(Rest)->
	{{bytestring_length, Length}, Rest1} = dec_bytestring_length(Rest, <<>>),
	{_Token, _Rest2} = dec_bytestring_content(Rest1,Length).
	
dec_bytestring_content(Source, LengthInBytes)->
	io:format("LengthInBytes ~p~n", [LengthInBytes]),
	LengthInBites = LengthInBytes * 8,
	<<Content:LengthInBites, Rest/binary>> = Source,
	io:format("Content ~p~n", [Content]),
	{{bytestring, LengthInBytes, <<Content:LengthInBites>>}, Rest}.
	
dec_bytestring_length(<<"0", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"0">>);
dec_bytestring_length(<<"1", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"1">>);
dec_bytestring_length(<<"2", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"2">>);
dec_bytestring_length(<<"3", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"3">>);
dec_bytestring_length(<<"4", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"4">>);
dec_bytestring_length(<<"5", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"5">>);
dec_bytestring_length(<<"6", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"6">>);
dec_bytestring_length(<<"7", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"7">>);
dec_bytestring_length(<<"8", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"8">>);
dec_bytestring_length(<<"9", Rest/binary>>, Acc)->
	dec_bytestring_length(Rest, <<Acc/binary,"9">>);
dec_bytestring_length(<<":", Rest/binary>>, Acc)->
	{{bytestring_length, list_to_integer(binary_to_list(Acc))}, Rest};
dec_bytestring_length(<<_Any:8, _Rest/binary>>, _Acc)->
	throw(bytestring_length_decode_error).
	
	
	
dec_number(<<"-", Rest/binary>>,<<>>)->
	dec_number(Rest, <<"-">>);
dec_number(<<"0", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "0">>);
dec_number(<<"1", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "1">>);
dec_number(<<"2", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "2">>);
dec_number(<<"3", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "3">>);
dec_number(<<"4", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "4">>);
dec_number(<<"5", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "5">>);
dec_number(<<"6", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "6">>);
dec_number(<<"7", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "7">>);
dec_number(<<"8", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "8">>);
dec_number(<<"9", Rest/binary>>,Acc)->
	dec_number(Rest, <<Acc/binary, "9">>);
dec_number(<<"e", Rest/binary>>,Acc)->
	{{number, list_to_integer(binary_to_list(Acc))}, Rest};
dec_number(<<_Any:8, _Rest/binary>>, _Acc)->
	throw(number_decode_error).
	