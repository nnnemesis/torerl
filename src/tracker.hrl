%%compact - comapct peer info
%% event = 'started', 'completed', 'stopped', '' - undefined
%% status = 'created', 'running', 'stoped', 'completed'

-define(UDP_INIT_CONNECTION_ID, <<0,0,4,23,39,16,25,128>>).
-define(UDP_CONNECT_ACTION, <<0:32>>).

-record(announce_url, {scheme, user_info, host, port, path, query, fragment}).

-record(announce_udp,{transaction_id, socket, connection_id}).

-record(announce_http,{compact=0,tracker_id}).

-record(track_data,{own_port, info_hash, peer_id ,uploaded=0 , downloaded=0 , total, status=created}).

-record(track,{announce_url, track_data, announce_data}).