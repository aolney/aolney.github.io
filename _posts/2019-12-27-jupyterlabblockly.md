---
layout: post
section-type: post
title: Fable JupyterLab Blockly Extension
category: Category
tags: ['research','education-research','datawhys','fsharp','data-science','machine-learning','programming','statistics']
---
A [JupyterLab](https://jupyterlab.readthedocs.io/en/stable/) [extension](https://jupyterlab.readthedocs.io/en/stable/user/extensions.html) that adds a [Blockly](https://developers.google.com/blockly) palette might be a good way to teach non-programmers data science!

I previously [adapted the JupyterLab extension tutorial](https://github.com/aolney/fable-jupyterlab-extension-demo) to [Fable](https://fable.io/), which means that extension developers can now use F# instead of JavaScript or TypeScript to write extensions.

[Today I got a new extension off the ground](https://github.com/aolney/fable-jupyterlab-blockly-extension) that creates a Blockly palette. Here's a demo:

<iframe width="560" height="315" src="https://www.youtube.com/embed/TZaj6d8Pt14" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

*Little* kids can use blocks languages. I gave the [Harry Potter Coding Wand](https://kano.me/store/us/products/coding-wand) as Xmas gifts last year - the box says ages 4 and up!

The idea here is to let non-programmers ease into data science by making the programming part dead simple. That way they can focus on the important parts: conceptual understanding, proper application of methods, and correct interpretation.

Of course, Blockly right now only has basic/generic blocks, so an important next step is extending it with blocks for [SciPy](https://www.scipy.org/), [pytorch](https://pytorch.org/), and other libraries.