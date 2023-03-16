FROM tomcat:9-jdk17

COPY ./src/FROST-Server.HTTP-2.2.0-SNAPSHOT.war /share/FROST-Server.war
COPY ./src/ $CATALINA_HOME/lib/

EXPOSE 8080
EXPOSE 9876

ARG UID=1000
ARG GID=1000

# && unzip -d ${CATALINA_HOME}/webapps/FROST-Server /tmp/FROST-Server.war \
RUN mkdir -p $CATALINA_HOME/conf/Catalina/localhost \
    && apt-get update && apt-get install unzip \
    && apt-get clean \
    && addgroup --system --gid ${GID} tomcat \
    && adduser --system --uid ${UID} --gid ${GID} tomcat \
    && mkdir -p $CATALINA_HOME/conf/Catalina/localhost \
    && chown -R tomcat:tomcat $CATALINA_HOME \
    && mkdir -p /share \
    && chown -R tomcat /share

USER tomcat
