FROM adoptopenjdk/openjdk8

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN  \
  apt-get update && apt-get install --no-install-recommends -y \
  gcc git openssh-client \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash developer

ARG idea_source=https://download.jetbrains.com/idea/ideaIC-2018.3.6.tar.gz
ARG idea_local_dir=.IdeaIC2018.3

WORKDIR /opt/idea

RUN curl -fsSL $idea_source -o /opt/idea/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.Idea \
  && ln -sf /home/developer/.Idea /home/developer/$idea_local_dir

CMD [ "/opt/idea/bin/idea.sh" ]
