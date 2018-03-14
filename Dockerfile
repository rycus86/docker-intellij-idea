FROM debian

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

# Set up installer for Oracle Java JDK 8
RUN apt-get update && apt-get install --no-install-recommends -y \
  gnupg2 dirmngr \
  && rm -rf /var/lib/apt/lists/*
RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list.d/java-8-debian.list
RUN echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list.d/java-8-debian.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

RUN  \
  apt-get update && apt-get install --no-install-recommends -y \
  gcc git openssh-client \
  oracle-java8-installer \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 \
  && rm -rf /var/lib/apt/lists/*

ARG idea_source=https://download-cf.jetbrains.com/idea/ideaIC-2017.3.5.tar.gz
ARG idea_local_dir=.IdeaIC2017.3

RUN mkdir /opt/idea
WORKDIR /opt/idea

ADD $idea_source /opt/idea/installer.tgz

RUN tar --strip-components=1 -xzf installer.tgz && rm installer.tgz

RUN useradd -ms /bin/bash developer
USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.Idea \
  && ln -sf /home/developer/.Idea /home/developer/$idea_local_dir

CMD [ "/opt/idea/bin/idea.sh" ]
