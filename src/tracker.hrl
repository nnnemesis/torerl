%%compact - comapct peer info
%% event = 'started', 'completed', 'stopped', 'undefined'

-define(UDP_INIT_CONNECTION_ID, <<0,0,4,23,39,16,25,128>>).
-define(UDP_CONNECT_ACTION, <<0:32>>).
-define(UDP_ANNOUNCE_ACTION, <<1:32>>).
-define(UDP_ANNOUNCE_PORT, 6881).

-record(announce_url, {scheme, user_info, host, port, path, query, fragment}).

-record(announce_udp,{socket, connection_id, key}).

-record(announce_http,{compact=0,tracker_id}).

-record(track_data,{own_port, announce_url, announce_url_parsed, info_hash
	, peer_id , uploaded=0 , downloaded=0 , total, event=started, key}).

-record(announce_response, {interval = 3600, leechers=0, seeders=0, ips=[], ports=[]}).

-record(track,{track_data, announce_data, announce_response}).