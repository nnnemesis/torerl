ok = cd("E:\\workspaces\\torerl\\src").


ok = file:delete("bencode_utils.beam").
ok = file:delete("bencode_utils_tests.beam").
ok = file:delete("bencoder.beam").
ok = file:delete("bencoder_tests.beam").
ok = file:delete("torrent_info.beam").
ok = file:delete("torrent_info_tests.beam").


{ok,bencode_utils} = c(bencode_utils).
{ok,bencode_utils_tests} = c(bencode_utils_tests).
{ok,bencoder} = c(bencoder).
{ok,bencoder_tests} = c(bencoder_tests).
{ok,torrent_info} = c(torrent_info).
{ok,torrent_info_tests} = c(torrent_info_tests).


ok = bencode_utils_tests:run_all_tests().
ok = bencoder_tests:run_all_tests().
ok = torrent_info_tests:run_all_tests().

