-module(tracker_utils_tests).
-compile(export_all).

run_all_tests()->
	test_generate_peer_id(),
	test_generate_transaction_id(),
	test_generate_key(),
	test_event_to_udp_param(),
	ok.
	
test_generate_peer_id()->
	PeerId = tracker_utils:generate_peer_id(),
	<<_Data:20/binary>> = PeerId.
	
test_generate_transaction_id()->
	TransactionId = tracker_utils:generate_transaction_id(),
	<<Id:4/binary>> = TransactionId.
	
test_generate_key()->
	Key = tracker_utils:generate_key(),
	<<Id:4/binary>> = Key.
	
test_event_to_udp_param()->
	<<0:32>> = tracker_utils:event_to_udp_param(undefined),
	<<1:32>> = tracker_utils:event_to_udp_param(completed),
	<<2:32>> = tracker_utils:event_to_udp_param(started),
	<<3:32>> = tracker_utils:event_to_udp_param(stopped).