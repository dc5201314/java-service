FROM openjdk:17-slim AS build
ENV HOME=/usr/app
RUN mkdir -p HOME
WORKDIR $HOME
ADD . $HOME
RUN --mount=type=cache,target=/root/.m2 ./mvn -f $HOME/pom.xml clean package

FROM openjdk:17-slim
ARG JAR_FILE=/usr/app/target/*.jar
COPY --from=build $JAR_FILE /app/runner.jar
EXPOSE 8081
ENTRYPOINT java -jar /app/runner.jar



