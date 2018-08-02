# E2E tests: Ubuntu, JDK8, Chrome / Firefox and Xvfb in Docker [![Build Status](https://travis-ci.org/daggerok/e2e-ubuntu-jdk8-xvfb.svg?branch=base)](https://travis-ci.org/daggerok/e2e-ubuntu-jdk8-xvfb)
automated build for docker hub

**Docker Ubuntu Trusty 14.04 image with Base Xvfb and JDK8**
**Docker Ubuntu Trusty 14.04 image with Chrome, Xvfb and JDK8**
**Docker Ubuntu Trusty 14.04 image with Firefox, Xvfb and JDK8**

Build based on `ubuntu:14.04` [official image](https://hub.docker.com/_/ubuntu/)
gecko driver version: `0.21.0`
chrome driver version: `2.41`

tags:

- [latest (master)](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/master/Dockerfile)
- [all](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/all/Dockerfile)
- [all-v2](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v2all)
- [all-v1](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v1all)

chrome:

- [latest](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/chrome/Dockerfile)
- [chrome-v2](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v2chrome)
- [chrome-v1](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v1chrome)

firefox:

- [latest](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/firefox/Dockerfile)
- [firefox-v2](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v2firefox)
- [firefox-v1](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v1firefox)

base:

- [latest](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/base/Dockerfile)
- [base-v2](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v2base)
- [base-v1](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v1base)

## Usage

### just create your test Dockerfile

```dockerfile

FROM daggerok/e2e-ubuntu-jdk8-xvfb:all
WORKDIR 'project-directory/'
ENTRYPOINT start-xvfb \
           && ./gradlew test chrome \
           && ./gradlew test firefox
COPY . .

```

```dockerfile

FROM daggerok/e2e-ubuntu-jdk8-xvfb:chrome
WORKDIR 'project-directory/'
ENTRYPOINT start-xvfb && ./gradlew test chrome
COPY . .

```

```dockerfile

FROM daggerok/e2e-ubuntu-jdk8-xvfb:firefox
WORKDIR 'project-directory/'
ENTRYPOINT start-xvfb && ./gradlew test firefox
COPY . .

```

```dockerfile

FROM daggerok/e2e-ubuntu-jdk8-xvfb:base
RUN echo 'install browser, webdriver and use already installed and configured jdk8 + Xvfb based on Ubuntu 14.04'

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

## Git

```bash

git tag $tagName # create tag
git tag -d $tagName # remove tag
git push origin --tags # push tags
git push origin $tagName # push tag

```
