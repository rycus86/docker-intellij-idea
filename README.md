Docker container to run IntelliJ IDEA Community Edition (https://www.jetbrains.com/idea/)

### Usage

```
docker run --rm \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.Idea:/home/developer/.Idea \
  -v ~/.Idea.java:/home/developer/.java \
  -v ~/.Idea.maven:/home/developer/.m2 \
  -v ~/.Idea.gradle:/home/developer/.gradle \
  -v ~/.Idea.share:/home/developer/.local/share/JetBrains \
  -v ~/Project:/home/developer/Project \
  --name idea-$(head -c 4 /dev/urandom | xxd -p)-$(date +'%Y%m%d-%H%M%S') \
rycus86/intellij-idea:latest
```

Docker Hub Page: https://hub.docker.com/r/rycus86/intellij-idea/

### Notes

The IDE will have access to AdoptOpenJDK 8 and to Git as well.
Project folders need to be mounted like `-v ~/Project:/home/developer/Project`.
The actual name can be anything - I used something random to be able to start multiple instances if needed.
You might want to consider using `--network=host` if you're running servers from the IDE.

#### UI Exception

Some Linux users may face `java.lang.NoClassDefFoundError` being thrown while running a container.
Well, actually, it is rather simple to solve this issue. See, when you are running a graphical application
on any Linux distro, it most definitely will try to create a connection to the X server.
But in some cases there will be a security extension called
[Xsecurity](https://www.x.org/releases/X11R7.7/doc/man/man7/Xsecurity.7.xhtml) and it will try to prevent
such behavior by default.

**To allow your containers to connect to the X server you'll need to use another X utility called `xhost`.**
But first you want to install it if you don't have one. Find a package name with this utility on your distro's
repositories *(e.g.: on Arch-based distros it will be in `xorg-xhost` package)*.
Then use it to allow all local connections:

```bash
xhost +local:
```

Or just allow them to a root user only:

```bash
xhost +si:localuser:root
```

#### Idea Access Denied Exception

Container runs with `developer` user by default, so if you don't have your mapped volumes directories
created, Docker will create them with a root user and Idea will not have access to them.

To solve this you should create volume directories by yourself with your default user or just
`chown` them after they were created and rerun the container.

