module Lev1 where

import Lib
import Data.Array

mft :: String -> String -> Array (Int, Int) Int
mft f t = m
  where
  m         = array bounds [ ((i, j), lev i j) | (i,j) <- range bounds ]
  bounds    = ((0, 0), (length t, length f))
  lev   0 0 = 0
  lev   0 j = succ $ m ! (0     , pred j)
  lev   i 0 = succ $ m ! (pred i, 0     )
  lev   i j | match     = m ! (pred i, pred j)
            | otherwise = 1 + minimum [ left, up, diag ]
        where
        match = (f !! pred j) == (t !! pred i)
        left  = m ! (pred i,      j)
        up    = m ! (     i, pred j)
        diag  = m ! (pred i, pred j)

score :: String -> String -> Int
score f t = mft f t ! (length t, length f)
