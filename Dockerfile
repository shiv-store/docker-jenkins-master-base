FROM local/shivaanta/centos8:latest

ENV TINI_VERSION v0.19.0

ONBUILD ARG JENKINS_USER
ONBUILD ARG JENKINS_UID
ARG JENKINS_GROUP=${JENKINS_USER}

RUN echo "${JENKINS_USER}----${JENKINS_USER}"
EXPOSE 8080

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini

RUN yum install -y java-11-openjdk \
            svn \
            git \
            sudo \
            perl-LDAP  && \
mkdir -p /usr/local/bin && \
mkdir -p /dist/jenkins && \
chmod 755 /dist/jenkins && \
chmod 0755 /usr/bin/tini && \
yum clean all && \
rm -rf /dist/java/*src.zip && \
rm -rf /dist/java/lib/visualvm && \
rm -rf /dist/java/lib/missioncontrol 

#INSTALL Jenkins 
ADD target/jenkins-war-*.war /dist/jenkins/jenkins.war
ADD bin/start-jenkins /usr/local/bin/start-jenkins
ADD bin/stop-jenkins /usr/local/bin/stop-jenkins
#ADD bin/hudauth.pl /usr/local/bin/hudauth.pl
RUN chmod 0755 /usr/local/bin/start-jenkins && \
    chmod 0755 /usr/local/bin/stop-jenkins 

ONBUILD RUN adduser ${JENKINS_USER} -u ${JENKINS_UID} && \
        chown -R ${JENKINS_USER}:${JENKINS_GROUP} /dist && \
        echo "${JENKINS_USER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${JENKINS_USER} && \
        chmod 0440 /etc/sudoers.d/${JENKINS_USER} && \
        chown ${JENKINS_USER}:${JENKINS_GROUP} /dist/jenkins/jenkins.war && \
        chown ${JENKINS_USER}:${JENKINS_GROUP} /usr/local/bin/start-jenkins && \
        chown ${JENKINS_USER}:${JENKINS_GROUP} /usr/local/bin/stop-jenkins 

ONBUILD ENV JENKINS_USER ${JENKINS_USER}
ONBUILD USER ${JENKINS_USER}
ENV PATH $JAVA_HOME/bin:$PATH
ENV JAVA_HOME=/usr/bin/java
ENV PATH $JAVA_HOME/bin:$PATH
ONBUILD CMD ["/usr/bin/tini","--","/usr/local/bin/start-jenkins"]


