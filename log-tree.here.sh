#!/bin/bash -u

function show-log-tree()
{
  if [ $# -lt 1 ]
  then
    echo "ERROR:show-log-tree: need one input argument
show-log-tree <log-tree.diff filename>"
  fi
  grep "Diff between .*.log .*.log" $1
  echo "--------------------------------------------"
  echo "Deleted files:"
  echo "--------------------------------------------"
  grep '>' $1
  echo "--------------------------------------------"
  echo "New files:"
  echo "--------------------------------------------"
  grep '<' $1
}

DIR_HERE="$(cd "$(dirname "$0")"; pwd)"
LOG_DIR="$DIR_HERE/log-tree/$(hostname)"

if [ ! -d "$LOG_DIR" ]
then
  mkdir -p "$LOG_DIR"
  touch "$LOG_DIR/log-tree.0.log"
fi

#software
OS=`uname -v`
if [[ ! "${OS//Ubuntu/}" == "$OS" ]]
then
  for i in tree
  do
    if [ -z "`dpkg -s $i 2> /dev/null`" ]
    then
      echo Need to install $i
      sudo apt-get install $i 1>&2
    fi
  done
fi

#checking if the log of today is already here
LOGS_OF_TODAY=`find $LOG_DIR -name log-tree.$(date +"%Y%m%d")\*.diff`
if [ ! -z "$LOGS_OF_TODAY" ]
then
  echo "The log-tree for $(date +"%Y%m%d") was already done. Showing it:"
  for i in $LOGS_OF_TODAY
  do
    if [ ! -e $i ]
    then
      echo "ERROR: cannot find log-tree file $i."
    else
      echo "--------------------------------------------"
      echo $i
      echo "--------------------------------------------"
      show-log-tree $i
    fi
  done
  exit
fi

LOG_FILE="$LOG_DIR/log-tree.$(date +"%Y%m%d-%H%M%S").log"
touch "$LOG_FILE"

echo building tree of "$DIR_HERE"
tree -f -i -a "$DIR_HERE" | grep -v '.dropbox.cache' | sort >> "$LOG_FILE"

cd "$LOG_DIR"
LOGS_TO_DIFF="$(ls -t *.log | head -n 2)"
echo Diff between $LOGS_TO_DIFF > "$LOG_FILE.diff"
diff $LOGS_TO_DIFF >> "$LOG_FILE.diff"
show-log-tree "$LOG_FILE.diff"
LOGS_TO_DELETE="$(ls -t *.log | tail -n +2)"
rm -fv $LOGS_TO_DELETE
cd - > /dev/null