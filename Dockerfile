FROM hypriot/rpi-java:latest

EXPOSE 8080

ENV DB_DIALECT MYSQL
ENV DB_URL jdbc:mysql://${DB_HOSTNAME}:3306/lavagna 
ENV DB_USER lavagna
ENV DB_PASS secret
ENV SPRING_PROFILE prod
ENV VERSION 1.0.7.2

RUN apt-get update && apt-get install ca-certificates unzip openssl && update-ca-certificates && \
    wget "https://github.com/digitalfondue/lavagna/releases/download/lavagna-${VERSION}/lavagna-${VERSION}-distribution.zip" && \
    unzip lavagna-${VERSION}-distribution.zip && rm -rf lavagna-${VERSION}-distribution.zip && \
    rm -rf lavagna-${VERSION}/bin && \
    apt-get remove unzip && apt-get autoremove && apt-get clean

CMD java -Xms64m -Xmx128m -Ddatasource.dialect="${DB_DIALECT}" \ 
-Ddatasource.url="${DB_URL}" \
-Ddatasource.username="${DB_USER}" \
-Ddatasource.password="${DB_PASS}" \
-Dspring.profiles.active="${SPRING_PROFILE}" \
-jar ./lavagna-${VERSION}/lavagna/lavagna-jetty-console.war --headless
