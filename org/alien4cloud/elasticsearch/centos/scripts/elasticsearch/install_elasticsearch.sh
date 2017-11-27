#!/bin/bash -e
source $commons/commons.sh


cd $INSTALL_PATH

# Download the application and install elasticsearch
download "ElasticSearch" "${APPLICATION_URL}" "elasticsearch.tar.gz"
tar -xvf elasticsearch.tar.gz
