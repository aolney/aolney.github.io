---
layout: post
section-type: post
title: Jupyterlab Blockly Polyglot Extension for JupyterLab 4.x
category: Category
tags: ['research','education-research','datawhys','data-science','machine-learning','programming','statistics']
---
A [JupyterLab extension that offers multilanguage intelliblock support](https://github.com/aolney/jupyterlab-blockly-polyglot-extension) compatible with JupyterLab 4.x!

We have created Blockly extensions for JupyterLab since late 2019. This new extension combines our Python and R extensions into an object oriented interface and makes it easier to add new languages (see the R support as an example, since Blockly provides no support for R natively).

This extension is backwards compatible with our notebooks but will emit new XML that is not backward compatible. In other words the extension silently upgrades your notebooks.

We have also added LLM integration for explaining errors and code, as well as next step hints.