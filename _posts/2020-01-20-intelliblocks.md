---
layout: post
section-type: post
title: Intelliblocks for the JupyterLab/Blockly Extension
category: Category
tags: ['research','education-research','datawhys','fsharp', 'data-science','machine-learning','programming','statistics','ldi']
---
My [Fable Jupyterlab Blockly Extension](https://olney.ai/category/2019/12/27/jupyterlabblockly.html) now has intelliblocks - blocks that use intellisense to call properties and functions on any Python library.

The intelliblocks address one of the key challenges with Blockly blocks - each block must be created somehow.
Since it takes me 10-30 minutes to create a block using [Blockly's developer tools](https://blockly-demo.appspot.com/static/demos/blockfactory/index.html), it could take weeks if not months to create blocks for a single library with hundreds of classes and thousands of members.
Since there are thousands of libraries out there, and they are constantly changing, creating blocks manually is effectively impossible.

I created the intelliblocks for my [Applied Computational Linguistics class](https://olney.ai/tags/teaching.html), so current usage focuses on calling high-level NLP libraries with these blocks, but the mechanism is sufficiently general that they should be useful for any application.

Below is a demonstration of the intelliblocks in action. 
It is important to note that since intellisense comes **from the kernel**, the blocks cannot configure themselves until the code has been executed **on the kernel**. 
This is necessarily true for dynamically typed languages like Python, though not for statically typed languages.

<iframe width="560" height="315" src="https://www.youtube.com/embed/70Q3RQi2KXc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<br>

[![NSF award information](/img/nsf-logo.png "NSF award information")](https://nsf.gov/awardsearch/showAward?AWD_ID=1918751&HistoricalAwards=false)
