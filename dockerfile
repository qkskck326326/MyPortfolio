# 1. Maven으로 빌드
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 2. Tomcat 이미지에 WAR 복사
FROM tomcat:9.0.85-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/target/myportfolio.war /usr/local/tomcat/webapps/ROOT.war