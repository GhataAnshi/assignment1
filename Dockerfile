FROM maven:latest AS build
COPY my-app/src /home/app/src
COPY my-app/pom.xml /home/app
COPY my-app/TestNG.xml /home/app

RUN mvn -f /home/app/pom.xml package

FROM openjdk:latest
COPY --from=build /home/app/target/my-app-1.0-SNAPSHOT.jar /usr/local/lib/my-app-1.0-SNAPSHOT.jar
CMD ["/usr/bin/java", "-cp", "/usr/local/lib/my-app-1.0-SNAPSHOT.jar", "com.mycompany.app.App"]
