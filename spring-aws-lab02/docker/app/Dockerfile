FROM amazoncorretto:11.0.21-alpine

VOLUME /tmp

WORKDIR /app
ADD spring-aws.jar /app
ADD ssl/springboot.p12 /usr/lib/jvm/java-11-amazon-corretto/lib/security
ADD --chmod=775 docker-entrypoint.sh /app

ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD [ "sh" ]