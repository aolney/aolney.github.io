---
layout: post
section-type: post
title: Computational Thinking through Modular Sound Synthesis
category: Category
tags: ['publications','research','education-research','engagement','ldi','mofacts','music','books','datawhys','programming','eurorack']
---

I wrote a book bridging computational thinking and electronic music this past semester while on sabbatical.

The goal of the book is to teach computational thinking practices *without programming*.
This idea has been around [for about 20 years](https://www.csunplugged.org/en/), but the new twist in my book is to use modular sound synthesis (modular) as the learning context.

Modular was developed in the 1950s, fell out of fashion in the 1980s, and regained popularity in the 2010s[^1]. 
Modular creates sounds and music by connecting together modules with patch cables, much like an old telephone switchboard. 
Each module performs some kind of operation on the incoming signals, and different overall effects can be achieved by patching up modules in different ways.

From a programming perspective, modular is a [dataflow language](https://en.wikipedia.org/wiki/Dataflow_programming) where the modules are often stateless. 
I would argue this makes modular easier to learn and to reason over than traditional programming because the control flow is visible as patch cables, and there is typically no hidden state in the form of variables and parameters[^2].

From a motivational perspective, this approach to modular shares many of the traits of [multimedia-based approaches to simplified programming](https://cacm.acm.org/magazines/2009/11/48421-scratch-programming-for-all/abstract): results are fairly immediate, of practical utility, and have an aesthetic dimension. 
However, such systems arguably have a downside, which is that they create walled gardens where children may learn to program but only as far as the environment will let them. 
In contrast, modular is modular - an open system with no limits.

The book uses [Cardinal](https://github.com/DISTRHO/Cardinal) a web browser port of the desktop virtual modular system [VCVRack](https://vcvrack.com/) to avoid a walled garden.
At the time of writing, there are 972 modules available in the version of Cardinal used by the book, and many of these are emulations of hardware modules.
The modular environment is directly embedded in the book, so users can open it with appropriate starter code, instructions, and solutions given for exercises corresponding to the concepts in that part of the book.

Hopefully, the book will be interesting and useful for both computational thinking and modular communities, and help spur more bridge-building between them in the future. 
To read the book, please visit [the book's website](https://olney.ai/ct-modular-book).

Andrew M. Olney. (2023). Computational Thinking through Modular Sound Synthesis.  https://doi.org/10.5281/zenodo.7502148

[^1]: The timeline roughly, and coincidentally, matches the popularity of neural networks
[^2]: Some modules, particularly digital modules, are configurable and store hidden parameters, e.g. parameters accessible using menu-based navigation on the module itself. 