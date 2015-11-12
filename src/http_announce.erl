-module(http_announce).
-export([]).

get_announce(Track)->
	AnnounceUrl = get_announce_url(Track),
	io:format("AnnounceUrl ~p~n", [AnnounceUrl]),
	{ok, RequestId} 
		= httpc:request(get, {AnnounceUrl, []}, [], [{sync, false}]),
	receive Any ->
		Any
	after 1000 -> 
		throw(get_announce_error)
	end.
	
get_announce_url(#track{announce_url = AnnounceUrl, info_hash = InfoHash
	, peer_id = PeerId, port = Port, uploaded = Uploaded
	, downloaded = Downloaded, left = Left, compact = Compact
	, tracker_id = TrackerId})->
	Port1 = integer_to_binary(Port),
	Uploaded1 = integer_to_binary(Uploaded),
	Downloaded1 = integer_to_binary(Downloaded),
	Left1 = integer_to_binary(Left),
	Compact1 = integer_to_binary(Compact),
	Event = event_to_binary(started),
	Params = [{info_hash, escape_uri(InfoHash)}
		, {peer_id, escape_uri(PeerId)}
		, {port, Port1}
		, {uploaded, Uploaded1}
		, {downloaded, Downloaded1}
		, {left, Left1}
		, {compact, Compact1}
		, {event, Event}],
	Params1 = case TrackerId of 
		undefined -> Params;
		_Other -> [{trackerid, TrackerId}|Params]
	end,
	Res = params_to_binary(Params1, <<AnnounceUrl/binary, "?">>),
	binary_to_list(Res).
	
	

event_to_binary(started)->
	<<"started">>;
event_to_binary(completed)->
	<<"completed">>;
event_to_binary(stopped)->
	<<"stopped">>;
event_to_binary(undefined)->
	<<>>;
event_to_binary(_Any)->
	throw(event_to_binary_error).
		
params_to_binary([], Acc)->
	Acc;
params_to_binary([{Key, Value}|[]], Acc)->
	Res = param_to_binary(Key, Value),
	<<Acc/binary, Res/binary>>;
params_to_binary([{Key, Value}|T], Acc)->
	Res = param_to_binary(Key, Value),
	params_to_binary(T, <<Acc/binary, Res/binary, "&">>).
		
param_to_binary(Key, Value) when is_atom(Key), is_binary(Value)->
	Key1 = atom_to_binary(Key, latin1),
	<<Key1/binary, "=", Value/binary>>;
param_to_binary(Key, Value) when is_binary(Key), is_binary(Value)->
	<<Key/binary, "=", Value/binary>>;
param_to_binary(Key, Value) ->
	throw(param_to_binary_error).
	
escape_uri(Source) when is_binary(Source) ->
	escape_uri(Source, <<>>).
	
escape_uri(<<C:8, Cs/binary>>, Acc) when C >= $a, C =< $z ->
    escape_uri(Cs, <<Acc/binary, C>>);
escape_uri(<<C:8, Cs/binary>>, Acc) when C >= $A, C =< $Z ->
    escape_uri(Cs, <<Acc/binary, C>>);
escape_uri(<<C:8, Cs/binary>>, Acc) when C >= $0, C =< $9 ->
    escape_uri(Cs, <<Acc/binary, C>>);
escape_uri(<<C:8, Cs/binary>>, Acc) when C == $. ->
    escape_uri(Cs, <<Acc/binary, C>>);
escape_uri(<<C:8, Cs/binary>>, Acc) when C == $- ->
    escape_uri(Cs, <<Acc/binary, C>>);
escape_uri(<<C:8, Cs/binary>>, Acc) when C == $_ ->
    escape_uri(Cs, <<Acc/binary, C>>);
escape_uri(<<C:1/binary, Cs/binary>>, Acc) ->
	C1 = escape_byte(C),
	escape_uri(Cs, <<Acc/binary, C1/binary>>);
escape_uri(<<>>, Acc) ->
    Acc.

escape_byte(C) ->
	<<H:4,L:4>> = C,
	<<"%", (hex_symbol(H)), (hex_symbol(L))>>.

hex_symbol(C) when C < 10 -> $0 + C;
hex_symbol(C) -> $a + C - 10.