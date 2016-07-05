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

I wanted it to look like the text was being edited.

This made me think of the Levenshtein-distance algorithm.

# Levenshtein?

## An Edit-Distance

<p class="transition" data-to="Between two things">Between two strings</p>

Imagine editing one string into another.

Each edit-action is associated with a cost.

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

## But crucially...

We are interested in reconstructing the edits!

A score isn't enough on its own, as the design goal is to have
the intermediate edits of the text displayed to the user.

This rules out the most optimal solutions.

However, we can still use...

## Full-Matrix

The full-matrix implementation of Levenshtein-distance allows for
reconstructing intermediate edits.

# Full-Matrix

## The values in the matrix describe the edit score.

                         --> Insertion
                  TO: R  A  B  B  I  T       Example: "CAT" -> "RABBIT"

                 +--+--+--+--+--+--+--+      Cells contain a score
                 | 0| 1| 2| 3| 4| 5| 6|      that indicates
                 +--+--+--+--+--+--+--+      the cost of editing
         FROM: C | 1| ?| ?| ?| ?| ?| ?|      up to that point.
                 +--+--+--+--+--+--+--+
            |  A | 2| ?| ?| ?| ?| ?| ?|      The point being M[i,j]
            v    +--+--+--+--+--+--+--+      where 'i' represents the
     Deletion  T | 3| ?| ?| ?| ?| ?| ?|      the index into the 'to'
                 +--+--+--+--+--+--+--+      word, and 'j' the 'from'.

Trivially, also works transposed due to symmetry.

## Arbitrary Cell

For any individual cell, the score can be derived in four possible ways,
corresponding to four possible edits.

    +---------+---------+
    |         |         |  Options include:
    |   <----\|    ^    |
    |   N,S   \  D |    |  * (N) Nothing       (+0 Points )
    |         |\   |    |  * (S) Substitution  (+1 Point  )
    +---------+-\ -| ---+  * (D) Deletion      (+1 Point  )
    |         |  \ |    |  * (I) Insertion     (+1 Point  )
    |   I     |   \|    |
    |   <----------?    |  (N) only if From[j] = To[i]
    |         |         |
    +---------+---------+  Pick the minimum option!

## First-Row and Column

        +---------+
        |         | "First Column"
        |    ^    |                           "First Row"
        |  D |    |    Options include:       +---------+---------+
        |    |    |                           |         |         |
        +-- -| ---+    * (I) Insertion (+1)   |   I     |         |
        |    |    |    * (D) Deletion  (+1)   |   <--------M[i,0] |
        |    |    |                           |         |         |
        | M[0,j]  |                           +---------+---------+
        |         |
        +---------+

* M[0,0] has a score of 0,
* Only Insertion/Deletion apply for M[i,0] and M[0,j]
* &#8756; M[i,0] = i and M[0,j] = j

## Inductive Definition

This is enough to give us a minimal inductive definition for the
scores of all cells of the matrix!

For String F, String T:

* M[0,0] = 0
* M[i,j] = M[i-1,j-1] if F[j] = T[i], otherwise
* M[i,j] = 1 + Minimum( M[i,j-1], M[i-1,j], M[i-1,j-1] )

## Spanning Tree

| | | | | | | |
| --- | --- | --- | --- | --- | --- | --- |
| <span style="color:red;">0</span> | <span style="color:red;">←</span> | ← | ← | ← | ← | ←
| ↑ | ↑ | <span style="color:red;">↖</span> | <span style="color:red;">↑</span> | <span style="color:red;">←</span> | ← | ←
| ↑ | ← | ↖ | ← | ← | <span style="color:red;">↖</span> | <span style="color:red;">←</span>
| ↑ | ← | ↑ | ← | ↑ | ← | <span style="color:red;">↑</span>

You can visualise this induction as a tree originating from the first cell of
M.

## The Final Score

For Words 'F', 'T':

The final score is the value in the last cell...

M[Length(T), Length(F)]

## Code

    mft f t = m where
      m       = array b [ ((i, j), lev i j) | (i,j) <- range b ]
      b       = ((0, 0), (length t, length f))
      lev 0 0 = 0
      lev 0 j = succ $ m ! (0     , pred j)
      lev i 0 = succ $ m ! (pred i, 0     )
      lev i j | match     = m ! (pred i, pred j)
              | otherwise = 1 + minimum [ left, up, diag ]
          where
              match = (f !! pred j) == (t !! pred i)
              left  = m ! (pred i,      j)
              up    = m ! (     i, pred j)
              diag  = m ! (pred i, pred j)

    score f t = mft f t ! (length t, length f)

Almost a literal translation.

# Reconstruction

## We don't just want the score...

               {
                 score :: Int,
                 state :: Text
               }

Since the branching corresponds to semantic editing actions,
you can keep an editing state in each cell, rather than just track
the score.

# Memoization

## asdf

# Laziness

## Bli bla
