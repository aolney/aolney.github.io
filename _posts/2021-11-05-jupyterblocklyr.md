---
layout: post
section-type: post
title: Jupyterlab Blockly R Extension
category: Category
tags: ['research','education-research','datawhys','data-science','machine-learning','programming','statistics']
---
A [JupyterLab extension that offers R intelliblock support](https://github.com/aolney/jupyterlab-blockly-r-extension) compatible with JupyterLab 1.2.x

This JupyterLab extension adds [Blockly](https://developers.google.com/blockly) support to [JupyterLab](https://jupyterlab.readthedocs.io/en/latest/#). 
Blockly is a visual programming language primarily designed to teach coding.
JupyterLab is a computational notebook environment widely used in data science as well as many scientific fields.

This extension also adds *intelliblocks*. Intelliblocks are Blockly blocks that *self-configure* based on loaded libraries.
This means you can load a library and immediately access everything in it using Blockly. 
Intelliblocks essentially automatically author Blockly blocks, which otherwise would need to be manually defined.

We previously introduced these features in [fable-jupyterlab-blockly-extension](https://github.com/aolney/fable-jupyterlab-blockly-extension), however, the global namespacing of Blockly meant that new Blockly languages would colide.
So we separated our work into Python and R extensions that could work side by side.