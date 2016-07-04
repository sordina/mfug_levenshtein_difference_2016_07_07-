---
title: "The Levenshtein Difference"
date: "2016, MFUG"
author: "Lyndon Maydwell"
link: "https://github.com/sordina/mfug_levenshtein_difference_2016_07_07-"
---

# So...

## I wanted to make a change to [silverpond.com.au](http://silverpond.com.au)

It used to say "we do data-science"...

![](images/silverpond.png)

But we do many things!

## An idea...

I thought a fun idea might be to have this text rewrite itself to various
declarations.

But how should it go about doing this?

I wanted it to look like the text was being edited, so immediately I thought of
the Levenshtein-distance algorithm.

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

Levenshtein-distance finds the smallest edit distance.

## Various Implementations

* Naively Recursive
* Full Matrix
* Two row itterative matrix
* Approximate

## But crucially... We are interested in reconstructing the edits!

A score isn't enough on its own, as the design goal is to have
the intermediate edits of the text displayed to the user.

## Full-Matrix

The full-matrix implementation of Levenshtein-distance allows for this.

## Full-Matrix Implementation

The values in the matrix describe the score for the edits to that point.

    +---------+---------+
    |         |         |
    |   <---- |    ^    |  Options include:
    |   N/S   \  I |    |
    |         |\   |    |  * (N) Nothing
    +---------+-\ -| ---+  * (S) Substitution
    |         |  \ |    |  * (I) Insertion
    |   D     |   \|    |  * (D) Deletion
    |   <----------?    |
    |         |         |
    +---------+---------+

# Memoization

## asdf

# Laziness

## Bli bla
