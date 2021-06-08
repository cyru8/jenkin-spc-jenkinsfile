FROM alpine/git as clone
#ARG url
WORKDIR /app
#RUN git clone ${url} (2)
RUN git clone https://github.com/cyru8/jenkin-spc-jenkinsfile.git

FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=clone app/jenkin-spc-jenkinsfile/target/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar /app
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar"]
