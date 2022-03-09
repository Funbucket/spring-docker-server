FROM openjdk:11-jdk

COPY ./build/libs/demo-*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]