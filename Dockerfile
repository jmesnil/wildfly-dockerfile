# By default, build on JDK 21.
ARG version=latest-jdk21
FROM quay.io/wildfly/wildfly-runtime:${version}

ENV WILDFLY_VERSION=37.0.1.Final
ENV GLOW_VERSION=1.5.0.Final

# Copy the user deployments (that's the only line to change)
COPY --chown=jboss:0 todo-backend.war deployments/

RUN curl https://jmesnil.github.io/wildfly.org/sh/install-glow | sh \
    && wildfly-glow/wildfly-glow scan deployments/* \
        --server-version=$WILDFLY_VERSION           \
        --cloud --add-ons=postgresql                \
        --provision=SERVER -d /opt/server           \
  # Clean up resources that are not need to run the server
  && rm -rf .m2 wildfly-glow