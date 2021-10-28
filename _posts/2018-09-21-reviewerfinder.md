---
layout: post
section-type: post
title: Reviewer Finder
category: Category
tags: ['service','reviewing','journal-reviewer','editor','nlp','fsharp']
---
Finding reviewers for an academic journal can be hard. I made a [search tool that can help](
https://olney.ai/jedm-reviewer-finder/).

The tool uses five years of available PDF proceedings, extracted to XML with [GROBID](https://github.com/kermitt2/grobid). Keyphrases for each paper are then extracted with [pke](https://github.com/boudinfl/pke), and a data model is created that associates each keyphrase with the authors of the paper that the keyphrase appeared in.

The data model is used in a [Fable](https://fable.io/) single-page application, i.e. 100% client-side scripting, to retrieve reviewers for some input text. The input text is copy/pasted from PDF into the browser. Ideally, `pke` would be used again to extract keywords, but to avoid the Python dependency, each keyword in the data model is checked using string search. I was concerned about performance and almost implemented Aho-Corasick, but I'm glad I didn't because performance is almost instantaneous with the naive approach.

The overall approach is high recall, low precision because `pke` is inherently low precision, and we match against all keywords in an input document rather than doing importance ranking. To help the user manage the low precision and explore the search result effectively, I use [react-table](https://react-table.js.org/).

Everything is [on GitHub](https://github.com/aolney/jedm-reviewer-finder), which is also [used for hosting](https://olney.ai/jedm-reviewer-finder/).

Demo:

<iframe width="560" height="315" src="https://www.youtube.com/embed/4HdtmNxaaKM" title="JEDM Reviewer Finder" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>