/usr/bin/wget --header='Content-Type:application/json' --post-data='{"jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "xbian", "params": {"directory":"'"$TR_TORRENT_DIR"'/"}}' "http://YOUR_KODI_USERNAME:YOUR_KODI_PASSWORD@localhost:8080/jsonrpc"

