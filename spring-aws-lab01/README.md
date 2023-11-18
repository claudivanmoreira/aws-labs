
# Spring AWS Lab 01

Nesse lab, deve ser construindo um backend básico em Spring Boot que seja executado em um container Docker.

## Requisitos

- Criar um projeto Gradle + Kotlin + Spring Boot
- Criar um endpoint `/echo` que retorne o PID do processo java, o nome da thread que recebeu a request e a porta em que o servidor está executando.
- Criar um `Dockerfile` que construa a imagem Docker do projeto.
- Criar um `docker-compose` que build a imagem do passo anterior e a execute em um container. Configurar o redirecionamento da porta 8080 local para a porta 7001 do container.

## Deploy

Na raiz do projeto, pelo terminal executar os seguintes comandos:

- Build do projeto: `./gradlew build`
- Deploy no container docker: `docker-compose up --build -d`

## Testes

Acessar no navegador o endereço `http://localhost:8080/echo`

## Resultado

![evidencia](https://github.com/claudivanmoreira/aws-labs/blob/main/spring-aws-lab01/src/test/resources/evidencia.PNG?raw=true)