# Use latest wildfly runtime image as the base
FROM quay.io/wildfly/wildfly-runtime-jdk11

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 26.1.1.Final
ENV WILDFLY_SHA1 c11076dd0ea3bb554c5336eeafdfcee18d94551d

USER root

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && microdnf install tar gzip \
    && curl -L -O https://github.com/wildfly/wildfly/releases/download/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME} \
    && ln -s $JBOSS_HOME /opt/jboss/wildfly
# the symbolic link to /opt/jboss/server is for backwards compatibility

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Expose the ports in which we're interested
EXPOSE 8080 9990