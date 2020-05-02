---
layout: post
section-type: post
title: MoFaCTS Automated Authoring
category: Category
tags: ['research','reading','education-research','mofacts','nlp','discourse','fsharp']
---
I've just released an intial version of code that reimplements and extends [previous work](https://olney.ai/category/2017/06/27/aiedcloze.html) for automatically creating cloze items from text.

The new implementation uses [AllenNLP](https://allennlp.org/) and [spaCy](https://spacy.io/) through Docker to provide deep-learning services, but the code itself use F# and [Fable](https://fable.io/) and so runs in the web browser. 

The final deployment is [actually in Meteor](https://github.com/memphis-iis/mofacts-ies), so I use Fable to output a Node target as well.

You can check out the code [here](https://github.com/aolney/mofacts-automated-authoring) or play with the [live demo here](https://olney.ai/mofacts-automated-authoring/), but the Docker services won't work unless you are on the University of Memphis campus.

Stevens Amendment Notice: This project is 100% financed with Federal funds at a dollar amount of $1,240,151. No non-governmental funds have been used to finance this project. 
