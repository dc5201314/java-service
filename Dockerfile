# 构建阶段
FROM openjdk:17-slim AS build

# 环境变量和工作目录
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME

# 将当前目录的所有文件添加到工作目录
ADD . $HOME

# 添加执行权限（确保 mvnw 可以执行）
RUN chmod +x ./mvnw

# 使用缓存构建项目
RUN --mount=type=cache,target=/root/.m2 ./mvnw -f $HOME/pom.xml clean package

# 打包阶段
FROM openjdk:17-slim
ARG JAR_FILE=target/*.jar
COPY --from=build $HOME/$JAR_FILE /app/runner.jar

# 暴露端口和启动命令
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app/runner.jar"]
