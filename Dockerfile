FROM adoptopenjdk/openjdk11:alpine-slim
COPY repo/build/libs/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]