FROM openjdk:8-jdk-alpine

VOLUME /tmp

USER root
EXPOSE 8080

ENV TOMCAT_VERSION=9.0.22 \
    MAVEN_VERSION=3.6.1 \
    STI_SCRIPTS_PATH=/usr/libexec/s2i

LABEL io.k8s.description="Platform for building and running JEE applications on Tomcat" \
      io.k8s.display-name="Tomcat Builder" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,tomcat" \
      io.openshift.s2i.destination="/opt/s2i/destination" \
      io.openshift.s2i.scripts-url=image://$STI_SCRIPTS_PATH

# Install Maven, Tomcat 9.0.22
RUN wget https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -zxvf ./apache-maven-$MAVEN_VERSION-bin.tar.gz -C /usr/local && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && \
    mkdir -p /tomcat && \
    wget http://www.apache.org/dist/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    tar -zxvf apache-tomcat-$TOMCAT_VERSION.tar.gz --strip 1 -C /tomcat && \
    rm -rf /tomcat/webapps/* && \
    mkdir -p /opt/s2i/destination

# Add s2i customizations
ADD ./m2/settings.xml $HOME/.m2/
ADD ./conf /tomcat/conf

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

RUN chmod -R a+rw /tomcat && \
    chmod a+rwx /tomcat/* && \
    chmod +x /tomcat/bin/*.sh && \
    chmod -R a+rw $HOME && \
    chmod -R +x $STI_SCRIPTS_PATH && \
    chmod -R g+rw /opt/s2i/destination

#USER 1001

CMD $STI_SCRIPTS_PATH/usage