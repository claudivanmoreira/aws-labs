#!/bin/sh

docker-compose up -d --remove-orphans

#docker-compose up --build --remove-orphans -d
#docker image prune -a -f

#1 - Gerar os certificados
#2 - Copiar o keystore para a pasta do app
#3 - Copiar o keystore para a pasta do jdk no container
#4 - Referenciar o keystore nas configs do Spring Boot
#5 - Copiar o .jar do projeto para a pasta do Docker <------ TODO
