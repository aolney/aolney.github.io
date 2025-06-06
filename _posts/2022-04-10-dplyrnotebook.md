---
layout: post
section-type: post
title: Dplyr Course in R Notebook
category: Category
tags: ['research','education-research','datawhys','data-science','machine-learning','programming','statistics']
---
We have created a [mini dpylr for data science course in R](https://github.com/memphis-iis/datawhys-content-dplyr/) using JupyterLab notebooks.
The course assumes little to no familiarity with R or dplyr.

The notebooks are designed to be used with [Blockly](https://developers.google.com/blockly) but can be used without it.
Blockly is a visual programming language primarily designed to teach coding.

The course outline covers core dplyr topics:

- Loading data
- The pipe: `%>%`
- Column operations
    - `select`
    - `mutate`/`transmute`
    - `rename`
- Row operations
    - `filter`
    - `arrange`
- Aggregation
    - `group_by`/`ungroup`
    - `summarize`
- Combining tables
    - `bind_cols`/`bind_rows`
    - `left_join`/`inner_join`/`full_join`
- Application to plotting