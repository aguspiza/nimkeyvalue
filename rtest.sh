#!/bin/bash -e
ALTDB=/tmp/indexdbalt/
echo "rebuild and rebalance test"
echo "Although this works with the master server running, you shouldn't do that!"
rebuild localhost:3001,localhost:3002 $ALTDB
rebalance localhost:3001 $ALTDB
rebalance localhost:3002 $ALTDB
rebalance localhost:3001,localhost:3002 $ALTDB

