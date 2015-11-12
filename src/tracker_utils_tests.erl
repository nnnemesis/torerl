-module(tracker_utils_tests).
-compile(export_all).

run_all_tests()->
	test_generate_peer_id(),
	ok.
	
test_generate_peer_id()->
	PeerId = tracker_utils:generate_peer_id(),
	<<_Data:20/binary>> = PeerId.