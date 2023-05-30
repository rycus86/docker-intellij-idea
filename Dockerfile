FROM --platform=${TARGETPLATFORM} debian

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN  \
  apt-get update && apt-get install --no-install-recommends -y \
  default-jdk gcc git openssh-client less curl \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash developer

ARG TARGETARCH
ARG IDEA_VERSION=2023.1
ARG IDEA_BUILD=2023.1.2
ARG idea_local_dir=.IdeaIC${IDEA_VERSION}

WORKDIR /opt/idea

RUN echo "Preparing IntelliJ IDEA ${IDEA_BUILD} ..." \
  && if [ "$TARGETARCH" = "arm64" ]; then export idea_arch='-aarch64'; else export idea_arch=''; fi \
  && export idea_source=https://download.jetbrains.com/idea/ideaIC-${IDEA_BUILD}${idea_arch}.tar.gz \
  && echo "Downloading ${idea_source} ..." \
  && curl -fsSL $idea_source -o /opt/idea/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.Idea \
  && ln -sf /home/developer/.Idea /home/developer/$idea_local_dir

CMD [ "/opt/idea/bin/idea.sh" ]
