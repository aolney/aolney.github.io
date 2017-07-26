---
layout: post
section-type: post
title: Install dotnet core on Debian sid (unstable) 
category: Category
tags: [ 'research', 'fsharp', 'braintrust' ]
---
- None of the existing installers worked at all
- Modified the [install script](https://gist.github.com/aolney/8d951cc15692e772e0ace8e27800555a) to handle Debian 9 and a bash shell. I've also recently (7/17) had luck with the bundled version [with instructions for linux here](https://www.microsoft.com/net/core#linuxdebian).
- After it runs do `find /opt/dotnet -name '*.so' -type f -print | xargs ldd | grep 'not found'` to see if you are missing any libraries
- For me, it was `liblldb.so`. I installed `liblldb-3.7` and then linked the library to `/usr/lib/x86_64-linux-gnu/liblldb.so`. You can handle other libraries similarly by linking.
- Even after this, `dotnet restore` would segfault, apparently [because dotnet depends on old versions of libcurl3](https://github.com/dotnet/core-setup/issues/545)
- Resolved by [adding stable.list to sources.list.d](https://serverfault.com/questions/22414/how-can-i-run-debian-stable-but-install-some-packages-from-testing), running `apt-get update`, and then running `apt-get install libcurl3=7.38.0-4+deb8u5 libcurl4-openssl-dev=7.38.0-4+deb8u5`
- Recently (7/17) I had to change my `/etc/apt/sources.list.d/stable.list` to specifically name `jessie` since `strech` is now stable, e.g. `deb     http://mirror.steadfast.net/debian/ jessie main contrib non-free`.
