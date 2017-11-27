#!/bin/bash

gen_certs(){
  cd $1

  password=changeit
  commonname=fastconnect
  country=FR
  state=Bretagne
  locality=Rennes
  organization=fastconnect
  organizationalunit=IT
  email=webmaster@fastconnect.fr
  altname=localhost
  hostip=$2

  ## certificate
  openssl genrsa -aes256 -passout pass:$password -out ca-key.pem 4096
  openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem -passin pass:$password -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

  ## server-key
  openssl genrsa -out server-key.pem 4096
  openssl req -subj "/CN=$commonname" -sha256 -new -key server-key.pem -out server.csr
  echo [SAN] > extfile.cnf ##this will allow to generate a certificate for all computes of you domain
  echo subjectAltName = IP:$hostip,DNS:$altname >>  extfile.cnf
  openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -passin pass:$password -out server-cert.pem -extfile extfile.cnf -extensions SAN

  ## client-key
  openssl genrsa -out key.pem 4096
  openssl req -subj "/CN=$commonname" -new -key key.pem -out client.csr
  echo extendedKeyUsage = clientAuth > extfile.cnf
  openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -passin pass:$password -out cert.pem -extfile extfile.cnf

  ## generate truststore
  JAVAHOME=`readlink -f /usr/bin/java | sed "s:bin/java::"`
  CACERTS=jre/lib/security/cacerts

  cp $JAVAHOME$CACERTS ./server-truststore.jks
  openssl x509 -outform der -in ca.pem -out ca.der
  keytool -import -alias alien4cloud -keystore server-truststore.jks -file ca.der -storepass changeit -noprompt

  ## generate server keystore
  openssl pkcs12 -export -name alien4cloud -in server-cert.pem -inkey server-key.pem -out server-keystore.p12 -chain -CAfile ca.pem -caname root -password pass:$password
  keytool -importkeystore -destkeystore server-keystore.jks -srckeystore server-keystore.p12 -srcstoretype pkcs12 -alias alien4cloud -deststorepass changeit -srcstorepass $password

  ## generate client keystore
  openssl pkcs12 -export -name alien4cloudClient -in cert.pem -inkey key.pem -out client-keystore.p12 -chain -CAfile ca.pem -caname root -password pass:$password
  keytool -importkeystore -destkeystore client-keystore.jks -srckeystore client-keystore.p12 -srcstoretype pkcs12 -alias alien4cloudClient -deststorepass changeit -srcstorepass $password

  cp server-keystore.jks ../bin/
}
