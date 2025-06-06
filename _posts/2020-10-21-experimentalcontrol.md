---
layout: post
section-type: post
title: JupyterLab Experimental Control Extension
category: Category
tags: ['research','education-research','datawhys','data-science','machine-learning','programming','statistics']
---
A [JupyterLab extension that adds gives experimental control to the JupyterLab interface](https://github.com/aolney/experimental-control) for JupyterLab 1.2.x.

The following `lock` behaviors are implemented:

- Left navbar collapsed (e.g. file explorer)
- Left navbar hidden
- Launcher and terminal tabs hidden
- Notebook tab close button disabled
- Bottom status bar hidden
- Auto renders markdown in case users accidentally double click

The following `qualtrics` behavior are implemented

- For WE/PS1, checks the expected number of code cells have been executed before giving password. This prevents experimental participants from moving forward without following direcitons to answer and execute each cell

**Qualtrics integration how-to:** Have a qualtrics question with a link to the notebook and a text entry box. Put a validator on the text entry box for the password returned by the extension. During the survey, the link out will take the participant to a JHub with the extension installed. When they complete a notebook, a link will appear giving them a password to enter on the Qualtrics side. Once they enter the password, Qualtrics will let them advance to the next question.