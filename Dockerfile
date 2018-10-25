FROM debian

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN  \
  # install dependencies
  apt-get update && apt-get install --no-install-recommends -y \
  gcc git openssh-client curl ca-certificates \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 && \
  rm -rf /var/lib/apt/lists/* && \ 
  # prepare folders
  mkdir -p /opt/idea && \
  mkdir -p /tmp/installer && \
  mkdir -p /opt/java && \
  # install OpenJDK 10
  curl -fsSL http://jdk.java.net/10/ | grep -oE '"https?://download.java.net/java/.*_linux-x64_bin.tar.gz"' | sed 's/"//g' > /tmp/installer/download.url && \
  echo "Downloading JDK from `cat /tmp/installer/download.url` ..." && \
  curl -fsSL `cat /tmp/installer/download.url` > /tmp/installer/jdk.tgz && \
  curl -fsSL `cat /tmp/installer/download.url`.sha256 > /tmp/installer/checksum && \
  echo "  /tmp/installer/jdk.tgz" >> /tmp/installer/checksum && \
  echo -n "Checksum check: " && sha256sum -c /tmp/installer/checksum && \
  echo "Download complete, extracting ..." && \
  tar --strip-components=1 -xzf /tmp/installer/jdk.tgz -C /opt/java && \
  rm -rf /tmp/installer && \
  for JAVA_BIN in /opt/java/bin/*; do \
    if [ -x "$JAVA_BIN" ]; then ln -s "$JAVA_BIN" /usr/bin/`basename "$JAVA_BIN"`; fi ; \
  done && \
  echo "Java binary is ready:" && \
  java -version 2>&1

ARG idea_source=https://download.jetbrains.com/idea/ideaIU-183.3975.18.tar.gz
ARG idea_local_dir=.IdeaIC2018.3

WORKDIR /opt/idea

ADD $idea_source /opt/idea/installer.tgz

RUN tar --strip-components=1 -xzf installer.tgz && \
  rm installer.tgz && \
  useradd -ms /bin/bash developer

USER developer

ENV HOME /home/developer
ENV JAVA_HOME "/opt/java"

RUN mkdir /home/developer/.Idea \
  && ln -sf /home/developer/.Idea /home/developer/$idea_local_dir

CMD [ "/opt/idea/bin/idea.sh" ]
