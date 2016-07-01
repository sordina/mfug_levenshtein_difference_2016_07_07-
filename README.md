---
title: "The Levenshtein Difference"
date: "2016, MFUG"
author: "Lyndon Maydwell"
link: "https://github.com/sordina/mfug_levenshtein_difference_2016_07_07-"
---

# What is it?

## An Edit-Distance

<p class="transition" data-to="Between two things">Between two strings</p>

Imagine that you had to edit one string into another, with costs associated with editor actions.

* Movement costs 0 points
* Replacement, Deletion, and Insertion cost 1 point

## An Edit-Distance

> "hello world" ▻ "hello swirled"

<p class="transition" data-to="hello swirled">hello world</p>

    ▻hello world 0  hell▻o world  0  hello sw▻orld 0  hello swirl▻d  0
    h▻ello world 0  hello▻ world  0  hello sw▻rld  1  hello swirle▻d 1
    he▻llo world 0  hello ▻world  0  hello swi▻rld 1  hello swirled▻ 0
    hel▻lo world 0  hello s▻world 1  hello swir▻ld 0

> 4 points

## But Optimal

Finds the smallest edit distance.

## Various Implementations

* Naively Recursive
* Full Matrix
* Two row itterative matrix
* Approximately

# Memoization

## asdf

# Laziness

## Bli bla
