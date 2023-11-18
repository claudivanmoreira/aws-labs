FROM amazoncorretto:11.0.21-alpine

VOLUME /tmp

ARG SOURCE_FILE=../build/libs/spring-aws-lab01.jar

COPY ${SOURCE_FILE} spring-aws.jar

ENTRYPOINT ["sh", "-c", "java -jar spring-aws.jar"]