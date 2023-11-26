DOMAIN=localhost

APP_KEYSTORE=springboot.p12
APP_CERTIFICATE=app-certificate.crt
APP_CERTIFICATE_PRIVATE_KEY=app-certificate-private-key.pem

NGINX_SELFSIGNED_CERT_NAME=nginx-selfsigned.crt
NGINX_SELFSIGNED_CERT_PRIVATE_KEY_NAME=nginx-selfsigned.key

DOCKER_APP_DIR=$1
DOCKER_NGINX_DIR=$2
CERTIFICATES_DIR=$3
KEYSTORE_DIR=$4
JAR_FILE=$5

rm -rf $CERTIFICATES_DIR
rm -rf $KEYSTORE_DIR
rm -rf $DOCKER_APP_DIR/ssl
rm -rf $DOCKER_NGINX_DIR/ssl
rm -rf $DOCKER_APP_DIR/spring-aws.jar

mkdir $CERTIFICATES_DIR
mkdir $KEYSTORE_DIR
mkdir $DOCKER_APP_DIR/ssl
mkdir $DOCKER_NGINX_DIR/ssl
cp $JAR_FILE $DOCKER_APP_DIR

## [1] - CRIA O CERTIFICADO SSL DA APLICACAO
##Generate certifcate and store it inside keystore
keytool -genkeypair \
        -alias springboot \
        -dname "CN=${DOMAIN},OU=Mock,O=Mock,L=Mock,C=BR" \
        -keyalg RSA \
        -keysize 4096 \
        -storetype PKCS12 \
        -keystore $KEYSTORE_DIR/$APP_KEYSTORE \
        -keypass changeit \
        -storepass changeit \
        -validity 365
#
### Export certificate from keystore
keytool -export \
        -keystore $KEYSTORE_DIR/$APP_KEYSTORE \
        -storepass changeit \
        -alias springboot \
        -file $CERTIFICATES_DIR/$APP_CERTIFICATE

### Export private key from certificate in keystore
openssl pkcs12 \
        -in $KEYSTORE_DIR/$APP_KEYSTORE \
        -nodes \
        -nocerts \
        -out $CERTIFICATES_DIR/$APP_CERTIFICATE_PRIVATE_KEY \
        -passin pass:changeit
#
### [2] - CRIA O CERTIFICADO SSL DO NGINX
openssl req -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -subj "//CN=${DOMAIN}\OU=Nginx Lab\O=Nginx Lab\L=Nginx Lab\ST=Nginx Lab\C=BR" \
        -keyout $CERTIFICATES_DIR/$NGINX_SELFSIGNED_CERT_PRIVATE_KEY_NAME \
        -out $CERTIFICATES_DIR/$NGINX_SELFSIGNED_CERT_NAME
##
#### https://gist.github.com/yidas/3701601c86dfaac6bb16016a3786be9a
openssl dhparam \
      -outform PEM \
      -out $CERTIFICATES_DIR/certsdhparam.pem 1024


cp $KEYSTORE_DIR/$APP_KEYSTORE $DOCKER_APP_DIR/ssl

cp $CERTIFICATES_DIR/$NGINX_SELFSIGNED_CERT_PRIVATE_KEY_NAME $DOCKER_NGINX_DIR/ssl
cp $CERTIFICATES_DIR/$NGINX_SELFSIGNED_CERT_NAME $DOCKER_NGINX_DIR/ssl
cp $CERTIFICATES_DIR/certsdhparam.pem $DOCKER_NGINX_DIR/ssl
cp $CERTIFICATES_DIR/$APP_CERTIFICATE_PRIVATE_KEY $DOCKER_NGINX_DIR/ssl
cp $CERTIFICATES_DIR/$APP_CERTIFICATE $DOCKER_NGINX_DIR/ssl
