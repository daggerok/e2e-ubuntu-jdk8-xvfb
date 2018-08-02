# E2E tests: Ubuntu, JDK8, Chrome and Xvfb in Docker [![Build Status](https://travis-ci.org/daggerok/e2e-ubuntu-jdk8-xvfb.svg?branch=chrome)](https://travis-ci.org/daggerok/e2e-ubuntu-jdk8-xvfb)
automated build for docker hub

**Docker Ubuntu Trusty 14.04 image with Chrome, Xvfb and JDK8**
chrome driver version: `2.39`

tags:

- [latest (master)](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/master/Dockerfile)
- [all](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/all/Dockerfile)

chrome:

- [latest](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/chrome/Dockerfile)
- [chrome-v1](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/tree/v1chrome)

firefox:

- [latest](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/firefox/Dockerfile)
- [firefox-v1](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v1firefox)

base:

- [latest](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/blob/base/Dockerfile)
- [base-v1](https://github.com/daggerok/e2e-ubuntu-jdk8-xvfb/tree/v1base)

## Usage

### just create your test Dockerfile


```docker

FROM daggerok/e2e-ubuntu-jdk8-xvfb:chrome
WORKDIR 'project-directory/'
ENTRYPOINT start-xvfb && ./gradlew -Si test chrome
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

## Git

```bash
git tag $tagName # create tag
git tag -d $tagName # remove tag
git push origin --tags # push tags
git push origin $tagName # push tag
```
