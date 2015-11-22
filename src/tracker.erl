-module(tracker).
-export([parse_announce_url/1, create_track_data/4
	, create_track/1, get_announce_data/1]).
-include("tracker.hrl").

create_track_data(OwnPort, AnnounceUrl, InfoHash, Total)->
	#track_data{own_port = OwnPort, announce_url = AnnounceUrl
		, info_hash = InfoHash, total = Total
		, peer_id = tracker_utils:generate_peer_id()
		, key = tracker_utils:generate_key()
		, announce_url_parsed = parse_announce_url(AnnounceUrl)}.

create_track(#track_data{} = TrackData) ->
	#track{
		track_data = TrackData
	}.
		
get_announce_data(#track{} = Track) ->
	case get_announce_type(Track) of
		udp -> 
			Track1 = udp_announce:init(Track),
			Track2 = udp_announce:udp_connect(Track1),
			Track3 = udp_announce:udp_announce(Track2),
			udp_announce:release(Track3);
		http -> throw(get_announce_data_error)
	end.

parse_announce_url(AnnounceUrl) when is_binary(AnnounceUrl) ->
	UrlString = binary_to_list(AnnounceUrl),
	{ok, Result} = http_uri:parse(UrlString),
	case Result of
		{Scheme, UserInfo, Host, Port, Path, Query, Fragment} ->
			#announce_url{scheme = Scheme, user_info = UserInfo
				,host = Host, port = Port, path = Path, query = Query, fragment = Fragment};
		{Scheme, UserInfo, Host, Port, Path, Query} ->
			#announce_url{scheme = Scheme, user_info = UserInfo
				,host = Host, port = Port, path = Path, query = Query}
	end.
	
get_announce_type(#track{track_data = #track_data{announce_url_parsed = Url}}) ->
	#announce_url{scheme = Scheme} = Url,
	Scheme.
	