---
layout: post
section-type: post
title: Question Classifier 2003 Reboot
category: Category
tags: ['research','autotutor','nlp','education-research','its','nlp','fsharp']
---
In 2003 I [published a paper](https://olney.ai/category/2003/01/01/Olney-A-Louwerse-M-Mathews-E-M.html) on classifying questions in AutoTutor.

The question classifier was originally written in TCL and used a cascade of manually authored regular expressions. Later on this code was ported to Java and C#. The only publically available implementation before now was bundled with [GnuTutor](https://olney.ai/category/2009/09/01/gnututor-overview.html) and wasn't validated to the degree of the original.

I've released a reimplementation using F# and [Fable](https://fable.io/) that runs in the web browser. Although it is not an exact reimplementation (using different programming languages, etc.) the test suite I've created for it shows that its performance is broadly similar to what I believe is the original code.

<iframe width="560" height="315" src="https://www.youtube.com/embed/kbK0eoi5ezM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

You can [go here for a live demo](https://olney.ai/question-classifier-2003-reboot/). The code [lives on GitHub](https://github.com/aolney/question-classifier-2003-reboot).

