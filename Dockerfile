FROM maven:latest AS build
#FROM ubuntu
COPY my-app/src /home/app/src
COPY my-app/pom.xml /home/app
COPY my-app/TestNG.xml /home/app

#ARG CHROME_VERSION="95.0.4638.69"
#RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*


RUN mvn -f /home/app/pom.xml package

FROM openjdk:latest
COPY --from=build /home/app/target/my-app-1.0-SNAPSHOT.jar /usr/local/lib/my-app-1.0-SNAPSHOT.jar
CMD ["/usr/bin/java", "-cp", "/usr/local/lib/my-app-1.0-SNAPSHOT.jar", "com.mycompany.app.App"]
