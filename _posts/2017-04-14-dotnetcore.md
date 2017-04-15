---
layout: post
section-type: post
title: Install dotnet core on Debian sid (unstable) 
category: Category
tags: [ 'research', 'fsharp' ]
---

- None of the existing installers worked at all
- Modified the [install script](https://gist.github.com/aolney/8d951cc15692e772e0ace8e27800555a) to handle Debian 9 and a bash shell
- After it runs do `find /opt/dotnet -name '*.so' -type f -print | xargs ldd | grep 'not found'` to see if you are missing any libraries
- For me, it was `liblldb.so`. I installed `liblldb-3.7` and then linked the library to `/usr/lib/x86_64-linux-gnu/liblldb.so`
