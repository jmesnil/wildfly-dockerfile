# WildFly Docker image

This is an example Dockerfile with [WildFly application server](http://wildfly.org/).

---
**NOTE**

Official builds for this image are now published to [https://quay.io/wildfly/wildfly](https://quay.io/wildfly/wildfly).  
Previous repository at [https://hub.docker.com/r/jboss/wildfly](https://hub.docker.com/r/jboss/wildfly) is no longer updated with new images

---

## Usage

To boot in standalone mode

    docker run -it quay.io/wildfly/wildfly
    
To boot in standalone mode with admin console available remotely

    docker run -p 8080:8080 -p 9990:9990 -it quay.io/wildfly/wildfly

To boot in domain mode

    docker run -it quay.io/wildfly/wildfly /opt/server/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0

## Application deployment

With the WildFly server you can [deploy your application in multiple ways](https://docs.jboss.org/author/display/WFLY8/Application+deployment):

1. You can use CLI
2. You can use the web console
3. You can use the management API directly
4. You can use the deployment scanner

The most popular way of deploying an application is using the deployment scanner. In WildFly this method is enabled by default and the only thing you need to do is to place your application inside of the `deployments/` directory. It can be `$JBOSS_HOME/standalone/deployments/` or `$JBOSS_HOMEy/domain/deployments/` depending on [which mode](https://docs.jboss.org/author/display/WFLY8/Operating+modes) you choose (standalone is default in the image -- see above).

The simplest and cleanest way to deploy an application to WildFly running in a container started from the `quay.io/wildfly/wildfly` image is to use the deployment scanner method mentioned above.

To do this you just need to extend the `quay.io/wildfly/wildfly` image by creating a new one. Place your application inside the `$JBOSS_HOME/standalone/deployments/deployments/` directory with the `ADD` command (but make sure to include the trailing slash on the deployment folder path, [more info](https://docs.docker.com/reference/builder/#add)). 

[A simple example](https://github.com/goldmann/wildfly-docker-deployment-example) was prepared to show how to do it, but the steps are following:

1. Create `Dockerfile` with following content:

        FROM quay.io/wildfly/wildfly
        ADD your-awesome-app.war $JBOSS_HOME/standalone/deployments/

2. Place your `your-awesome-app.war` file in the same directory as your `Dockerfile`.
3. Run the build with `docker build -t wildfly-app .`
4. Run the container with `docker run -it -p 8080:8080 wildfly-app`. Application will be deployed on the container boot.

This way of deployment is great because of a few things:

1. It utilizes Docker as the build tool providing stable builds
2. Rebuilding image this way is very fast (once again: Docker)
3. You only need to do changes to the base WildFly image that are required to run your application

## Logging

Logging can be done in many ways. [This blog post](https://goldmann.pl/blog/2014/07/18/logging-with-the-wildfly-docker-image/) describes a lot of them.

## Customizing configuration

Sometimes you need to customize the application server configuration. There are many ways to do it and [this blog post](https://goldmann.pl/blog/2014/07/23/customizing-the-configuration-of-the-wildfly-docker-image/) tries to summarize it.

## Extending the image

To be able to create a management user to access the administration console create a Dockerfile with the following content

    FROM quay.io/wildfly/wildfly
    RUN $JBOSS_HOME/bin/add-user.sh admin Admin#70365 --silent

This will create an management user with the name `admin` and the password `Admin#70365`.

Then you can build the image:

    docker build -tag jboss/wildfly-admin .

Run it:

    docker run -it -p 8080:8080 -p 9990:9990 jboss/wildfly-admin

Administration console will be available on the port `9990` of the container.

## Building on your own

You don't need to do this on your own, because we prepared a trusted build for this repository, but if you really want:

    docker build --rm=true --tag=jboss/wildfly .

## Image internals

This image extends the [`quay.io/wildfly/wildfly-runtime-jdk11`](https://quay.io/repository/wildfly/wildfly-runtime-jdk11?tab=info) image which provides an OpenJDK11 runtimes to run WildFly. Please refer to the README.md for selected images for more info.

The server is run as the `jboss` user which has the uid/gid set to `1000`.

WildFly is installed in the `/opt/server` directory and it can be referenced with the `JBOSS_HOME` environment variable.

## Source

The source is [available on GitHub](https://github.com/jboss-dockerfiles/wildfly).

## Issues

Please report any issues or file RFEs on [GitHub](https://github.com/jboss-dockerfiles/wildfly/issues).
