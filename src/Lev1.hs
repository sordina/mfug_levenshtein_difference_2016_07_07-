module Lev1 where

import Data.Array

mft :: String -> String -> Array (Int, Int) Int
mft f t   = m where
  m       = array bounds [ ((i, j), lev i j) | (i,j) <- range bounds ]
  bounds  = ((0, 0), (length t, length f))
  lev 0 0 = 0
  lev 0 j = succ $ m ! (0     , pred j)
  lev i 0 = succ $ m ! (pred i, 0     )
  lev i j | (f!! p j) == (t !! p i) = m!(p i,p j)
          | otherwise = 1 + minimum [ m!(p i,j), m!(i,p j), m!(p i,p j) ]

score :: String -> String -> Int
score f t = let m = mft f t in m ! snd (bounds m)

p = pred
