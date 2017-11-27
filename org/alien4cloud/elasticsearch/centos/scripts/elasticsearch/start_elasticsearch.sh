#!/bin/bash -e
cd $INSTALL_PATH/elasticsearch-1.7.6/bin
nohup ./elasticsearch > /dev/null 2>&1 &
echo "ES launched"
