---
layout: post
section-type: post
title: BrainTrust Electron Client
category: Category
tags: [ 'research', 'fsharp', 'braintrust' ]
---
The Electron version of the BrainTrust client is [now on GitHub](https://github.com/aolney/braintrust-electron).

The previous version (used in the NSF EAGER work) was a Silverlight application; however, as major browsers began to discontinue support for plugins, Silverlight is no longer viable.

After a ton of design work considering

- 3D agent support
- Text to speech
- Cross platform capability

I decided to use [Electron](https://github.com/electron/electron-quick-start), which is really a Node/Chrome application that presents itself as a desktop application, in order for BrainTrust to be as cross platform as Chrome is.

Additionally, I decided to develop using [Fable](http://fable.io/), a very cool transpiler that lets me code in F# and compile to Javascript.
