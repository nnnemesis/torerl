-module(tracker).
-export([parse_announce_url/1, create_track/5]).
-include("tracker.hrl").

create_track(OwnPort, AnnounceUrl, InfoHash, Total, PeerId) when is_binary(AnnounceUrl)->
	#track{
		announce_url = parse_announce_url(AnnounceUrl),
		track_data = #track_data{
			own_port = OwnPort
			, info_hash = InfoHash
			, total = Total
			, peer_id = PeerId
		}
	}.

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