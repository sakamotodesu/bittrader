FROM eclipse-temurin:11-jre
COPY build/libs/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]