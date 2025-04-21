# 1. 使用 Maven 官方镜像
FROM maven:3.8.5-openjdk-17-slim AS build

# 2. 设置工作目录
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME

# 3. 复制项目文件到工作目录
ADD . $HOME

# 4. 使用缓存构建项目
RUN --mount=type=cache,target=/root/.m2 mvn -f $HOME/pom.xml clean package

# 5. 创建运行时镜像
FROM openjdk:17-slim

# 6. 设置 JAR 文件的路径
ARG JAR_FILE=target/*.jar
COPY --from=build $HOME/$JAR_FILE /app/runner.jar

# 7. 暴露端口
EXPOSE 8081

# 8. 设置容器启动的命令
ENTRYPOINT ["java", "-jar", "/app/runner.jar"]
