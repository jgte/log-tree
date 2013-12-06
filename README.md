Log a tree
==========

Keep track of files in a directory tree. usage:

`log-tree.here.sh`

The script creates in the current directory the sub-directory log-tree/$(hostname) and places there files with the recursive list of all files below the current directory. When the `log-tree.here.sh` is again issued on another day, the files that are were deleted and the files that are new are printed to the screen.

The file listings are in plain text. The diffs between consecutive days is kept and the only complete listing concerns the one relative to the current day (or the most recent day the command was issued).

A good application for this script is to keep track of files in Dropbox (or any other cloud or auto-synchronization system), possibly in an automated fashion if used in conjunction with crontab.