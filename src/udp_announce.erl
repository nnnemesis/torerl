-module(udp_announce).
-export([]).

init_udp_connect(#udp_tracker{own_port = OwnPort} = UdpTracker)->
	{ok, Socket} = gen_udp:open(OwnPort, [binary, {active,false}]),
	UdpTracker#udp_tracker{socket = Socket}.
	
close_udp_connect(#udp_tracker{socket = Socket})->
	gen_udp:close(Socket).

udp_connect(#udp_tracker{remote_addr = RemoteAddr, remote_port = RemotePort,
	socket = Socket} = UdpTracker)->	
	%ConnectionId = <<0,0,4,23,39,16,25,128>>,
	%ConnectAction = <<0:32>>,
	TransactionId = random:uniform(5000),
	ConnectMessage = get_connect_message(TransactionId),
	gen_udp:send(Socket, RemoteAddr, RemotePort, ConnectMessage),
	{ok, {RemoteAddrRes, RemotePort, ResContent}} = gen_udp:recv(Socket, 0, 5000),
	<<ConnectActionRes:4/binary, TransactionIdRes:4/binary, ConnectionIdGen:8/binary>> = ResContent,
	UdpTracker#udp_tracker{transaction_id = TransactionId, connection_id = ConnectionIdGen}.
	
get_connect_message(TransactionId)->
	<<?UDP_INIT_CONNECTION_ID/binary, ?UDP_CONNECT_ACTION/binary, <<TransactionId:32>>>>.