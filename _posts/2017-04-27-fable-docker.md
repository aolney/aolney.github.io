---
layout: post
section-type: post
title: Fable 1.0 in Linux Docker Container with dotnet
category: Category
tags: [ 'research', 'fsharp', 'braintrust' ]
---
I've been working with a really fantastic [f# to javascript compiler called fable](http://fable.io/). Basically I can write f# programs, compile to javascript, and run in browser, node, or electron.

Fable has gone through a lot of changes the past year, and the latest version, 1.0, relies on [dotnet core](https://www.microsoft.com/net/core). While that seems a very nice idea, dotnet core itself is pretty new and tends to segfault on my platform of choice, Debian unstable.

You can muck around and make it work, but since unstable is well, unstable, those changes have a tendancy to be undone with updates. So I thought I'd try to make a docker image with all the goodies.

Here's how:

1. Make sure you have docker installed
2. `docker pull microsoft/dotnet:1.0.4-sdk`
3. `docker run -it microsoft/dotnet:1.0.4-sdk`
4. You are now root in the docker container in an interactive shell session. Install the necessary tools for fable
  - `curl -sL https://deb.nodesource.com/setup_7.x | bash -`
  - `apt-get install -y nodejs`
  - `apt-get install -y build-essential`
  - `npm install --global yarn`
5. This part is tricky. If you don't do this all files you make will be owned by root!
  - On your host OS, find you user in `/etc/passwd` and remember the numeric id
  - In the container, `useradd -m yourusername`
  - In the container, check that the numeric id in `/etc/passwd` is the same as host, change if not
6. In a new terminal in the host, 
  - get the docker container id with `docker ps`
  - commit your new image with `docker commit containerid yourhandle/yourimagename`
7. Now `exit` the interactive shell session
8. Execute a command like this to begin working with fable: `docker run --user 1000 -v /z/aolney:/z/aolney -it aolney/fable-dotnet-104`

This command:

- Maps file permissions to user 1000 (for me the same on host and container)
- Maps a directory on the host to the container (so I can access my local fable repo)
- Creates an interactive shell session using image `aolney/fable-dotnet-104`

Once the command is executed I can go to the relevant fable repo and start issuing dotnet core commands, have them update the host file system with correctly permissioned files, and generally be happy.

In the case of the awesome recent [fable-getting-started](https://github.com/fable-compiler/fable-getting-started), I would head over to the directory in question, `dotnet restore GettingStarted.sln` , `yarn install`, and then `yarn run watch`. An overview of the Fable 1.0 project structure and dotnet commands is [here](http://fable.io/blog/Introducing-1-0-beta.html).

I considered adding vscode to the image, but with the frequent changes it sees, I didn't want to bother with updating and committing all the time. Maybe I will change my mind about that later. Something else that could potentially be improved is where dotnet restore keeps things. Currently this in in the container, to things will disappear when the container is restarted.
