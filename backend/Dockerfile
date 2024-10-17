FROM openjdk:17-jdk-alpine

WORKDIR /app

COPY target/backend-0.0.1-SNAPSHOT.jar app.jar
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

ENV SPRING_PROFILES_ACTIVE dev,prod

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
