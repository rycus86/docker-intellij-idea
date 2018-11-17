FROM adoptopenjdk/openjdk8

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN  \
  apt-get update && apt-get install --no-install-recommends -y \
  gcc git openssh-client \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 \
  && rm -rf /var/lib/apt/lists/*

ARG idea_source=https://download.jetbrains.com/idea/ideaIC-183.4284.107.tar.gz
ARG idea_local_dir=.IdeaIC2018.3

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
