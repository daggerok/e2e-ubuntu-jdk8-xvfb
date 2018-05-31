FROM ubuntu:14.04
LABEL MAINTAINER='Maksim Kostromin <daggerok@gmail.com> https://github.com/daggerok'
ENV DISPLAY=':99' \
    CHROME_DRV_VER='2.39' \
    GECKO_DRV_VER='0.20.1' \
    DEBIAN_FRONTEND='noninteractive' \
    JAVA_HOME='/usr/lib/jvm/java-8-oracle'
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ARG JAVA_OPTS_ARGS='\
    -Djava.net.preferIPv4Stack=true \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+UseCGroupMemoryLimitForHeap \
    -XshowSettings:vm'
ENV JAVA_OPTS="${JAVA_OPTS} ${JAVA_OPTS_ARGS}"
# execute e2e tests as non root, but sudo user
USER root
RUN apt update \
 && apt install -y htop sudo openssh-server vim \
 && useradd -m e2e && echo "e2e:e2e" | chpasswd \
 && adduser e2e sudo \
 && echo "\ne2e ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && service ssh restart \
 && chown -R e2e:e2e /home/e2e
WORKDIR /home/e2e
USER e2e
# prepare
RUN sudo apt-get update -y \
 && sudo apt-get install -y wget bash software-properties-common
# jdk8
RUN sudo apt-add-repository -y ppa:webupd8team/java \
 && sudo apt-get update -y \
 && sudo echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections \
 && sudo echo debconf shared/accepted-oracle-license-v1-1   seen true | sudo debconf-set-selections \
 && sudo apt-get install -y oracle-java8-installer oracle-java8-set-default oracle-java8-unlimited-jce-policy
# firefox
RUN sudo add-apt-repository ppa:mozillateam/firefox-next \
 && sudo apt-get update -y \
 && sudo apt-get install -y firefox
# gecko driver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v${GECKO_DRV_VER}/geckodriver-v${GECKO_DRV_VER}-linux64.tar.gz \
 && tar -xvzf geckodriver* \
 && sudo mv -f geckodriver /usr/bin/ \
 && sudo chmod +x /usr/bin/geckodriver
# chrome
RUN sudo apt-get install -y fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
      libatk1.0-0 libcairo2 libcups2 libgdk-pixbuf2.0-0 libgtk-3-0 \
      libnspr4 libnss3 libx11-xcb1 libxss1 xdg-utils \
 && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && sudo sudo dpkg -i google-chrome-stable_current_amd64.deb \
 && rm -rf ./google-chrome-stable_current_amd64.deb
# chrome driver
RUN wget https://chromedriver.storage.googleapis.com/${CHROME_DRV_VER}/chromedriver_linux64.zip \
 && unzip chromedriver_linux64.zip \
 && sudo mv -f chromedriver /usr/bin/ \
&& rm -rf chromedriver_linux64.zip
# xvfb stuff
RUN sudo apt-get install -y xvfb xorg xvfb dbus-x11 xfonts-100dpi xfonts-75dpi xfonts-cyrillic \
 && echo '#!/bin/bash \n\
echo "starting Xvfb..." \n\
sudo Xvfb -ac :99 -screen 0 1280x1024x16 & \n' \
      >> ./start-xvfb \
 && chmod +x ./start-xvfb \
 && sudo mv -f ./start-xvfb /usr/bin/
# docker exec -it
CMD /bin/bash

# usage: 
## 1) build based image first:
# docker build -t daggerok/e2e-ubuntu-jdk8-xvfb .
## 2) create own e2e tests Dockerfile:
# FROM daggerok/e2e-ubuntu-jdk8-xvfb
# WORKDIR /home/e2e/project-directory
# ENTRYPOINT sudo chown -R e2e:e2e ~/ \
#              && . /usr/bin/start-xvfb \
#              && ./gradlew test firefox && ./gradlew test chrome
# COPY . .
## 3) build, run tests copy reports from docker container and if needed - open it in browser
# cd path/to/for/example/gradle/selemiun/test/project-directory
# docker build -t my-e2e-tests:latest .
# docker run --name run-my-e2e-tests my-e2e-tests:latest
# docker cp run-my-e2e-tests:/home/e2e/project-directory/test/reports ./reports
# open ./reports/tests/test/index.html
