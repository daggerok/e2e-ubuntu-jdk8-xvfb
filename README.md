# E2E tests: Ubuntu, JDK8, Firefox and Xvfb in Docker [![Build Status](https://travis-ci.org/daggerok/e2e-ubuntu-jdk8-xvfb.svg?branch=firefox)](https://travis-ci.org/daggerok/e2e-ubuntu-jdk8-xvfb)
automated build for docker hub

**Docker Ubuntu Trusty 14.04 image with Firefox, Xvfb and JDK8**

Build based on `daggerok/e2e-ubuntu-jdk8-xvfb:base` [image](https://hub.docker.com/r/daggerok/e2e-ubuntu-jdk8-xvfb) which is based on `ubuntu:14.04` [official image](https://hub.docker.com/_/ubuntu/)

## Usage

### just create your test Dockerfile


```docker

FROM daggerok/e2e-ubuntu-jdk8-xvfb:base
WORKDIR 'project-directory/'
ENTRYPOINT start-xvfb && ./gradlew -Si test firefox
COPY . .

```

### build test image

```bash

docker build -t my-e2e-tests:latest .

```

### and run tests

```bash

docker run --rm --name run-my-e2e-tests my-e2e-tests:latest

```

## Reduce build time

In real big projects resolving dependencies each time might take long time and sometimes it's not what we want...
So we can try reuse existing local `~/.gradle` and `~/.m2` folders to reduce build time. 
To do so, just mount needed folder on during docker run:

```bash

docker build -t my-e2e-tests:latest .
mkdir -p ~/.gradle/caches/modules-2/files-2.1 ~/.m2/repository
docker run --rm --name run-my-e2e-tests \
  -v ~/.gradle/caches/modules-2/files-2.1:/home/e2e/.gradle/caches/modules-2/files-2.1 \
  -v ~/.m2/repository:/home/e2e/.m2/repository \
  my-e2e-tests

```

**WARNING**

Sometines it might cause some strange and not obviouse problems for `file not found` or `permission denied` topics...
So use it only if you know what you are doing and if you ready to spend time for some debugginh :)
