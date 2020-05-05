FROM adoptopenjdk/openjdk11:alpine-slim
COPY /home/circleci/project/repo/build/libs/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]