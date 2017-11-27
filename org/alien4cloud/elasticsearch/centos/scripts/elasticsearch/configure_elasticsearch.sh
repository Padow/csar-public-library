#!/bin/bash -e
ES_PATH=$INSTALL_PATH/elasticsearch
if [[ $SECURED == "true" ]]; then
	cd $ES_PATH/bin
	./plugin --install search-guard-ssl --url https://fastconnect.org/maven/service/local/repositories/opensource/content/com/floragunn/search-guard-ssl/1.7.0/search-guard-ssl-1.7.0.zip
	cd ../config

	source $commons/keygen.sh
	gen_certs $ES_PATH/config $ES_IP


echo '
cluster.name: ${CLUSTER_NAME}
node.name: a4c_node1
node.master: true
node.data: true
index.number_of_shards: 1
index.number_of_replicas: 1
path.logs: ${INSTALL_PATH}/elasticsearch/logs
discovery.zen.ping.multicast.enabled: false
discovery.zen.ping.unicast.enabled: true
discovery.zen.ping.unicast.hosts: ${ES_IP}
searchguard.ssl.http.clientauth_mode: REQUIRE
searchguard.ssl.http.enable_openssl_if_available: false
searchguard.ssl.http.enabled: true
searchguard.ssl.http.keystore_filepath: ${ES_PATH}/config/server-keystore.jks
searchguard.ssl.http.keystore_password: changeit
searchguard.ssl.http.truststore_filepath: ${ES_PATH}/config/server-truststore.jks
searchguard.ssl.http.truststore_password: changeit
searchguard.ssl.transport.enable_openssl_if_available: false
searchguard.ssl.transport.enabled: true
searchguard.ssl.transport.enforce_hostname_verification: true
searchguard.ssl.transport.resolve_hostname: false
searchguard.ssl.transport.keystore_filepath: ${ES_PATH}/server-keystore.jks
searchguard.ssl.transport.keystore_password: changeit
searchguard.ssl.transport.truststore_filepath: ${ES_PATH}/server-truststore.jks
searchguard.ssl.transport.truststore_password: changeit
' > elasticsearch.yml
else
	cd $ES_PATH/config
echo '
cluster.name: ${CLUSTER_NAME}
node.name: a4c_node1
node.master: true
node.data: true
index.number_of_shards: 1
index.number_of_replicas: 1
path.logs: ${INSTALL_PATH}/elasticsearch/logs

' > elasticsearch.yml
fi
