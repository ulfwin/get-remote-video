# get-remote-video
Script that searches and downloads videos in folders on a remote server

Uses ssh and heredoc to search for files, and scp to download.

The script takes one or two regex arguments. If two, they will be used as logic AND.
