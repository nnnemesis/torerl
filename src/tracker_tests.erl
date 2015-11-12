-module(tracker_tests).
-compile(export_all).
-include("tracker.hrl").

run_all_tests()->
	test_parse_announce_url(),
	test_parse_announce_url_2(),
	ok.

test_parse_announce_url()->
	#announce_url{scheme = udp, user_info = []
		,host = "bt.rutor.org", port = 2710
		,path = "/", query = [], fragment = undefined} 
		= tracker:parse_announce_url(<<"udp://bt.rutor.org:2710">>).
		
test_parse_announce_url_2()->
	#announce_url{scheme = http, user_info = []
		,host = "retracker.local", port = 80
		,path = "/announce", query = [], fragment = undefined} 
		= tracker:parse_announce_url(<<"http://retracker.local/announce">>).