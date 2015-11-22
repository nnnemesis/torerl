-module(udp_announce).
-export([init/1, release/1, udp_connect/1, get_connect_message/1
	, udp_announce/1]).
-include("tracker.hrl").

init(Track)->
	{ok, Socket} = gen_udp:open(?UDP_ANNOUNCE_PORT, [binary, {active,false}]),
	Track#track{announce_data = #announce_udp{socket = Socket}}.
	
release(#track{announce_data = AnnounceData} = Track)->
	#announce_udp{socket = Socket} = AnnounceData,
	gen_udp:close(Socket),
	Track.

udp_connect(#track{announce_data = AnnounceData, track_data = TrackData} = Track) ->
	#announce_udp{socket = Socket} = AnnounceData,
	#track_data{announce_url_parsed = AnnounceUrl} = TrackData,
	#announce_url{host = RemoteAddr, port = RemotePort} = AnnounceUrl,
	TransactionId = tracker_utils:generate_transaction_id(),
	ConnectMessage = get_connect_message(TransactionId),
	gen_udp:send(Socket, RemoteAddr, RemotePort, ConnectMessage),
	{ok, {RemoteAddrRes, RemotePort, ResContent}} = gen_udp:recv(Socket, 0, 5000),
	<<ConnectActionRes:4/binary, TransactionIdRes:4/binary, ConnectionIdGen:8/binary>> = ResContent,
	TransactionIdRes = TransactionId, %check transaction id
	Track#track{announce_data = AnnounceData#announce_udp{connection_id = ConnectionIdGen}}.

udp_announce(#track{announce_data = AnnounceData, track_data = TrackData} = Track) ->
	#announce_udp{socket = Socket, connection_id = ConnectionId} = AnnounceData,
	#track_data{announce_url_parsed = AnnounceUrl, info_hash = InfoHash
		, peer_id = PeerId, downloaded = Downloaded
		, total = Total, uploaded = Uploaded, event = Event
		, key = Key, own_port = OwnPort} = TrackData,
	#announce_url{host = RemoteAddr, port = RemotePort} = AnnounceUrl,
	TransactionId = tracker_utils:generate_transaction_id(),
	Left = Total - Downloaded,
	AnnounceMessage = get_announce_message(ConnectionId, TransactionId
		, InfoHash, PeerId, Downloaded, Left, Uploaded
		, tracker_utils:event_to_udp_param(Event)
		, Key, OwnPort),
	gen_udp:send(Socket, RemoteAddr, RemotePort, AnnounceMessage),
	{ok, {RemoteAddrRes, RemotePort, ResContent}} = gen_udp:recv(Socket, 0, 5000),
	io:format("ResContent ~p~n", [ResContent]),
	<<ActionResp:4/binary, TransactionResp:4/binary
		, Interval:32, LeechersCount:32, SeedersCount:32
		, IpsAndPortsResp/binary>> = ResContent,
	
	io:format("IpsAndPortsResp ~p~n", [IpsAndPortsResp]),
	
	%checks
	ActionResp = ?UDP_ANNOUNCE_ACTION,
	TransactionResp = TransactionId,	
		
	ClientCount = 4*(LeechersCount+SeedersCount),
	<<AllIps:ClientCount/binary, AllPorts/binary>> = IpsAndPortsResp,
	IpsList = parse_ips(AllIps, []),
	PortsList = parse_ports(AllPorts, []),
	
	%checks
	IpsLength = length(IpsList),
	PortsLength = length(PortsList),
	IpsLength = PortsLength,
	
	AnnounceResponse = #announce_response{leechers = LeechersCount
		, seeders = SeedersCount, ips = IpsList, ports = PortsList
		, interval = Interval},
	Track#track{announce_response = AnnounceResponse}.
	
parse_ports(<<>>, Acc)->
	Acc;
parse_ports(<<Port:2/binary, Rest/binary>> = Ports, Acc) when is_binary(Ports) ->
	parse_ports(Rest, [Port|Acc]).
	
parse_ips(<<>>, Acc)->
	Acc;
parse_ips(<<Ip:4/binary, Rest/binary>> = Ips, Acc) when is_binary(Ips) ->
	parse_ips(Rest, [Ip|Acc]).
	
get_connect_message(TransactionId)->
	<<?UDP_INIT_CONNECTION_ID/binary, ?UDP_CONNECT_ACTION/binary, TransactionId/binary>>.
	
get_announce_message(ConnectionId, TransactionId, InfoHash, PeerId
	, Downloaded, Left, Uploaded, Event, Key, Port)->
	IP_DEFAULT = <<0:32>>,
	NUM_WANT_DEFAULT = <<-1:32>>,
	
	<<ConnectionId/binary, ?UDP_ANNOUNCE_ACTION/binary
		,TransactionId/binary, InfoHash/binary
		,PeerId/binary, Downloaded:64
		,Left:64, Uploaded:64
		, Event/binary, IP_DEFAULT/binary
		, Key/binary, NUM_WANT_DEFAULT/binary
		, Port:16>>.