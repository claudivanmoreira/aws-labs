
# Spring AWS Lab 02

Nesse lab, deve ser construido um backend básico em Spring Boot que aceite requisições HTTPS e que esteja configurado com
NGINX como loadbalancer.

Exemplo:

![evidencia](https://github.com/claudivanmoreira/aws-labs/blob/main/spring-aws-lab02/src/test/resources/ideia.PNG?raw=true)

## Requisitos

### Aplicação
 
- Criar um projeto Gradle + Kotlin + Spring Boot
- Gerar certificado HTTPS auto-assinado.
- Configurar certificado HTTPS na aplicação para ler/escrever dados de forma protegida
- Criar um endpoint `/echo` que retorne o PID do processo java, o nome da thread que recebeu a request e o nome da 
instância do serviço que recebeu a request.
- Criar um `Dockerfile` que construa a imagem Docker do projeto.

### Nginx

- Gerar um certificado HTTPS auto-assinado.
- Configurar utilização de certificado HTTPS.
- Configurar regras de segurança: ratelimit, session timeout, limite de banda, permissões de acesso, XSS, politica de conteudo, remocao do header de versao do nginx.
- Configurar balanceamento de carga entre as instâncias do backend
- Criar um `Dockerfile` que construa a imagem Docker do nginx com todas as configurações e arquivos necessários.

### Configuração

- Criar um `docker-compose` que suba 2 instâncias do backend e 1 instância do nginx
- Ao acessar a porta não segura do nginx em `http://localhost:80/echo` a request deve ser redirecionada para `https://localhost/echo`
- Cria tasks no arquivo build.gradle para simplificar o build e containerização da solução

## Deploy

Na raiz do projeto, pelo terminal executar os seguintes comandos:

- Build do projeto: `./gradlew docker-build`
- Deploy no container docker: `./gradlew docker-run`

## Testes

1. Acessar no navegador o endereço `http://localhost:80/echo`

## Resultado

1. Infra estrutura em execução:

- Containers Docker

![evidencia](https://github.com/claudivanmoreira/aws-labs/blob/main/spring-aws-lab02/src/test/resources/containers.PNG?raw=true)


- Logs nginx

![evidencia](https://github.com/claudivanmoreira/aws-labs/blob/main/spring-aws-lab02/src/test/resources/nginx_https.PNG?raw=true)

- Logs backend

![evidencia](https://github.com/claudivanmoreira/aws-labs/blob/main/spring-aws-lab02/src/test/resources/spring_https.PNG?raw=true)

2. Redirecionamento para porta HTTPS do nginx:

![evidencia](https://github.com/claudivanmoreira/aws-labs/blob/main/spring-aws-lab02/src/test/resources/nginx_https_redirect.PNG?raw=true)

3. Loadbalancer em ação

![evidencia](https://github.com/claudivanmoreira/aws-labs/blob/main/spring-aws-lab02/src/test/resources/loadbalancer.gif?raw=true)