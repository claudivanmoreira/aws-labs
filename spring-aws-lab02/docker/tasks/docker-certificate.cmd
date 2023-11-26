@echo off

set DOMAIN=localhost

set APP_KEYSTORE=springboot.p12
set APP_CERTIFICATE=app-certificate.crt
set APP_CERTIFICATE_PRIVATE_KEY=app-certificate-private-key.pem

set NGINX_SELFSIGNED_CERT_NAME=nginx-selfsigned.crt
set NGINX_SELFSIGNED_CERT_PRIVATE_KEY_NAME=nginx-selfsigned.key

set DOCKER_APP_DIR=%1
set DOCKER_NGINX_DIR=%2
set CERTIFICATES_DIR=%4
set KEYSTORE_DIR=%5
set JAR_FILE=%6

rmdir /S /Q %CERTIFICATES_DIR%
rmdir /S /Q %KEYSTORE_DIR%
rmdir /S /Q %DOCKER_APP_DIR%\ssl
rmdir /S /Q %DOCKER_NGINX_DIR%\ssl
del /F /Q %DOCKER_APP_DIR%\spring-aws.jar

:: goto comment

mkdir %CERTIFICATES_DIR%
mkdir %KEYSTORE_DIR%
mkdir %DOCKER_APP_DIR%\ssl
mkdir %DOCKER_NGINX_DIR%\ssl
COPY %JAR_FILE% %DOCKER_APP_DIR%

:: [1] Create application certificate and keys
:: Generate certifcate and store it inside keystore
keytool -genkeypair ^
        -alias springboot ^
        -dname "CN=%DOMAIN%,OU=Mock,O=Mock,L=Mock,C=BR" ^
        -keyalg RSA ^
        -keysize 4096 ^
        -storetype PKCS12 ^
        -keystore %KEYSTORE_DIR%\%APP_KEYSTORE% ^
        -keypass changeit ^
        -storepass changeit ^
        -validity 365

:: Export certificate from keystore
keytool -export ^
        -keystore %KEYSTORE_DIR%\%APP_KEYSTORE% ^
        -storepass changeit ^
        -alias springboot ^
        -file %CERTIFICATES_DIR%\%APP_CERTIFICATE%

:: Download and install from https://slproweb.com/products/Win32OpenSSL.html
:: Export private key from certificate in keystore
echo QUIT | openssl pkcs12 ^
        -in %KEYSTORE_DIR%\%APP_KEYSTORE% ^
        -nodes ^
        -nocerts ^
        -out %CERTIFICATES_DIR%\%APP_CERTIFICATE_PRIVATE_KEY% ^
        -passin pass:changeit

:: [2] Create NGINX certificate
:: Crete ssl certificate for nginx
echo QUIT | openssl req -x509 ^
        -nodes ^
        -days 365 ^
        -newkey rsa:2048 ^
        -subj "/CN=%DOMAIN%/OU=Nginx Lab/O=Nginx Lab/L=Nginx Lab/ST=Nginx Lab/C=BR" ^
        -keyout %CERTIFICATES_DIR%\nginx-selfsigned.key ^
        -out %CERTIFICATES_DIR%\nginx-selfsigned.crt

:: https://gist.github.com/yidas/3701601c86dfaac6bb16016a3786be9a
echo QUIT | openssl dhparam ^
      -outform PEM ^
      -out %CERTIFICATES_DIR%\certsdhparam.pem 1024

COPY %KEYSTORE_DIR%\%APP_KEYSTORE% %DOCKER_APP_DIR%\ssl

COPY %CERTIFICATES_DIR%\%NGINX_SELFSIGNED_CERT_PRIVATE_KEY_NAME% %DOCKER_NGINX_DIR%\ssl
COPY %CERTIFICATES_DIR%\%NGINX_SELFSIGNED_CERT_NAME% %DOCKER_NGINX_DIR%\ssl
COPY %CERTIFICATES_DIR%\certsdhparam.pem %DOCKER_NGINX_DIR%\ssl
COPY %CERTIFICATES_DIR%\%APP_CERTIFICATE_PRIVATE_KEY% %DOCKER_NGINX_DIR%\ssl
COPY %CERTIFICATES_DIR%\%APP_CERTIFICATE% %DOCKER_NGINX_DIR%\ssl
:: :comment