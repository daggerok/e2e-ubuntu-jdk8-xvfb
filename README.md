# E2E tests: Ubuntu, JDK8, Firefox, Chrome and Xvfb in Docker
automated build for docker hub

**Docker base image for E2E selenium testing on Chrome and Firefox browsers with Xvfb configured and JDK8 installed**

Build based on `ubuntu:14.04` [official image](https://hub.docker.com/_/ubuntu/)

tags:

- [latest](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/master/Dockerfile)

## Usage

### just create your test Dockerfile

```docker

FROM daggerok/e2e-ubuntu-jdk8-xvfb
WORKDIR /home/e2e/project-directory
ENTRYPOINT sudo chown -R e2e:e2e ~/ \
             && . /usr/bin/start-xvfb \
             && ./gradlew -Si test firefox
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

links:

- [E2E | Ubuntu | JDK8 | Firefox | Xvfb | Docker](https://github.com/daggerok/e2e-ubuntu-jdk8-firefox-xvfb)
- [E2E | Ubuntu | JDK8 | Chrome | Xvfb | Docker](https://github.com/daggerok/e2e-ubuntu-jdk8-chrome-xvfb)
- [E2E | Ubuntu | JDK8 | Firefox + Chrome | Xvfb | Docker](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb)
