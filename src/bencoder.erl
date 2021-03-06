-module(bencoder).
-export([decode/1, encode/1]).
	
%%EXPORT
%%DECODE
decode(FileData) when is_binary(FileData) ->
	{Terms, <<>>} = dec(FileData, []),
	lists:reverse(Terms).
%%DECODE
%%ENCODE
encode(BencodeTerm)->
	encode(BencodeTerm, <<>>).
%%ENCODE
%%EXPORT
	
%%INTERNAL
%%TO_BINARY
encode([], Acc)->
	Acc;
encode([H|T], Acc)->
	encode(T, encode(H, Acc));
encode({number, N}, Acc)->
	Res = case N < 0 of
		true -> 
			BN = integer_to_binary(0-N),
			<<"i-", BN/binary, "e">>;
		false -> 
			BN = integer_to_binary(N),
			<<"i", BN/binary, "e">>
	end,
	<<Acc/binary, Res/binary>>;
encode({list, Content}, Acc)->
	InternalAcc = encode(Content, <<>>),
	<<Acc/binary, "l", InternalAcc/binary, "e">>;
encode({dict, Content}, Acc)->
	InternalAcc = encode(Content, <<>>),
	<<Acc/binary, "d", InternalAcc/binary, "e">>;
encode({bytestring, SizeInBytes, Content}, Acc)->
	BN = integer_to_binary(SizeInBytes),
	<<Acc/binary, BN/binary, ":", Content/binary>>;
encode(_Any, _Acc)->
	throw(encode_error).
	
%%TO_BINARY

%%PARSE
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
	LengthInBites = LengthInBytes * 8,
	<<Content:LengthInBites, Rest/binary>> = Source,
	{bencode_utils:make_bytestring(<<Content:LengthInBites>>, LengthInBytes), Rest}.
	
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
%%PARSE