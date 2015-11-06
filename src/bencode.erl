-module(bencode).
-export([make_bytestring/1, make_bytestring/2]).

%%MAKE
make_bytestring(Content) when is_bitstring(Content) ->
	{bytestring,byte_size(Content),Content}.
make_bytestring(Content, ByteSize) when is_bitstring(Content) ->
	{bytestring,ByteSize,Content}.
%%MAKE