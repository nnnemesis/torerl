-module(tracker_utils).
-export([generate_peer_id/0]).

generate_peer_id()->
	Rand1 = random:uniform(5000),
	Rand2 = random:uniform(5000),
	Rand3 = random:uniform(5000),
	Rand4 = random:uniform(5000),
	Rand5 = random:uniform(5000),
	<<Rand1:32, Rand2:32, Rand3:32, Rand4:32, Rand5:32>>.