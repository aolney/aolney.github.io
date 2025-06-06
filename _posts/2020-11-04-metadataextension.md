---
layout: post
section-type: post
title: JupyterLab Metadata Extension
category: Category
tags: ['research','education-research','datawhys','data-science','machine-learning','programming','statistics']
---
A [JupyterLab extension that uses cell metadata to inject html/javacript into JupyterLab](https://github.com/aolney/metadata-html-extension), for JupyterLab 1.2.x.

**It is extremely useful for playing videos in JupyterLab, though it has many uses.**

This approach overcomes the limitations of JupyterLab markdown cells for certain types of html, such as iframes, that appear to be stripped/sanitized based on the JupyterLab security model.

Using this extension therefore increases the likelihood that an attacker may use a notebook to execute arbitrary code on your computer.

This extension is meant for research purposes only and is not meant for general usage. 

**Obviously, notebooks with html in the metadata will not render properly without this extension.**s

Example metadata:

```javascript
{
    "html": "<iframe class='metadata-html' width='560' height='315' src='https://www.youtube.com/embed/nBrKsT1IvIM' frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe>"
}
```

`class='metadata-html'` will prevent duplicate html injection if switching between notebooks.
