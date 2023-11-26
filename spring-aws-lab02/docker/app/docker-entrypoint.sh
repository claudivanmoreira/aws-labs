#!/bin/sh

cd /app

#keytool -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass ${KEYSTORE_PASSWORD} -noprompt -trustcacerts -importcert -alias ${CERTIFICATE_ALIAS} -file ${CERTIFICATE_FILE}

java -jar spring-aws.jar