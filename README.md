# E2E tests: Ubuntu, JDK8, Firefox, Chrome and Xvfb in Docker
automated build for docker hub

**Docker base Ubuntu Trusty 14.04 image with Xvfb configured and JDK8 installed**

__all you need is install browser and it's webdriver (see daggerok/e2e-ubuntu-jdk8-firefox-xvfb or daggerok/e2e-ubuntu-jdk8-chrome-xvfb images as example)__

Build based on `ubuntu:14.04` [official image](https://hub.docker.com/_/ubuntu/)

tags:

- [latest](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/master/Dockerfile)

## Usage

### just create your test Dockerfile

```docker

FROM daggerok/e2e-ubuntu-jdk8-xvfb
RUN echo 'install browser, webdriver and use already installed and configured jdk8 + Xvfb based on Ubuntu 14.04'
```

links:

- [E2E | Ubuntu | JDK8 | Firefox | Xvfb | Docker](https://github.com/daggerok/e2e-ubuntu-jdk8-firefox-xvfb)
- [E2E | Ubuntu | JDK8 | Chrome | Xvfb | Docker](https://github.com/daggerok/e2e-ubuntu-jdk8-chrome-xvfb)
- [E2E | Ubuntu | JDK8 | Xvfb | base Docker image](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb)
