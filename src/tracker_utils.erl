-module(tracker_utils).
-export([generate_peer_id/0, generate_transaction_id/0
	, generate_key/0, event_to_udp_param/1]).

event_to_udp_param(Event)->
	case Event of
		started -> <<2:32>>;
		completed -> <<1:32>>;
		stopped -> <<3:32>>;
		undefined -> <<0:32>>
	end.
	
generate_peer_id()->
	Rand1 = random:uniform(5000),
	Rand2 = random:uniform(5000),
	Rand3 = random:uniform(5000),
	Rand4 = random:uniform(5000),
	Rand5 = random:uniform(5000),
	<<Rand1:32, Rand2:32, Rand3:32, Rand4:32, Rand5:32>>.
	
generate_transaction_id()->
	Rand1 = random:uniform(5000),
	<<Rand1:32>>.

generate_key()->
	Rand1 = random:uniform(5000),
	<<Rand1:32>>.