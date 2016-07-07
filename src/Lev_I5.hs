
import Criterion.Main
import Data.Array
import Data.Ord
import Data.List.Zipper
import Data.Aeson (encode)
import Data.List  (minimumBy, nub)

import qualified Data.Number.Nat            as N
import qualified Data.ByteString.Lazy.Char8 as LBS


-- Text Functions

type Text = Zipper Char

iT, sT :: Char -> Text -> Text
iT  c = right . insert  c
sT  c = right . replace c

dT, nT :: Text -> Text
dT = delete
nT = right

-- Data

data Cell = C { state  :: Text
              , target :: Text
              , score  :: N.Nat } deriving (Eq, Show)

link :: Text -> Text -> N.Nat -> [Cell] -> [Cell]
link x t s p = C x t s : p

-- Convenience functions

scoreH :: [Cell] -> N.Nat
scoreH = score . head

stateH :: [Cell] -> Text
stateH = state . head

charH :: [Cell] -> Char
charH = cursor . target . head

targetH :: [Cell] -> Text
targetH = target . head

-- Matrix Operations

iM, dM, sM, nM :: Array (Int,Int) [Cell] -> Int -> Int -> [Cell]
iM m i j = link (iT (charH p) (stateH p)) (right (targetH p)) (scoreH p + 1) p where p = m ! (pred i,      j)
dM m i j = link (dT           (stateH p))        (targetH p)  (scoreH p + 1) p where p = m ! (     i, pred j)
sM m i j = link (sT (charH p) (stateH p)) (right (targetH p)) (scoreH p + 1) p where p = m ! (pred i, pred j)
nM m i j = link (nT           (stateH p)) (right (targetH p)) (scoreH p    ) p where p = m ! (pred i, pred j)

-- Algo

levensteini :: String -> String -> [Cell]
levensteini a b = snd $ last $ levsl
  where
  levsl     = [ ((i, j), lev i j) | (i,j) <- range bnds ]
  bnds      = ((0, 0), (length b, length a))
  levsv     = array bnds levsl
  ind   w i = w !! (pred i)
  mini      = minimumBy (comparing scoreH)

  lev   0 0 = [ C (fromList a) (fromList b) 0 ]
  lev   0 j = dM levsv 0 j
  lev   i 0 = iM levsv i 0
  lev   i j | (ind a j) == (ind b i) = nM levsv i j
            | otherwise              = mini [ iM levsv i j, dM levsv i j, sM levsv i j ]

levenstein :: String -> String -> N.Nat
levenstein a b = score $ head $ levensteini a b

levenwords :: String -> String -> [String]
levenwords a b = nub $ reverse $ map (toList . state) $ levensteini a b


phrases :: [ String ]
phrases = [ "We do data-science"
          , "We do consulting"
          , "We do design"
          , "We do user-experience"
          , "We do deep-learning"
          , "We do products"
          , "We do product-development"
          , "We do software-engineering"
          , "We do software-development"
          , "We do software-science"
          ]

pairs :: [(String, String)]
pairs = zip phrases (tail phrases) ++ [(last phrases, head phrases)]

runLev :: String -> String -> IO ()
runLev a b = mapM_ putStrLn $ levenwords a b

{-
main :: IO ()
main = LBS.putStrLn $ encode $ map (uncurry levenwords) pairs
-}

setupEnv = do
  let small = replicate 1000 (1 :: Int)
  big <- map length . words <$> readFile "/usr/share/dict/words"
  return (small, big)

main :: IO ()
main = defaultMain [
   -- notice the lazy pattern match here!
   env setupEnv $ \ ~(small,big) -> bgroup "main" [
   bgroup "small" [
     bench "length" $ whnf length small
   , bench "length . filter" $ whnf (length . filter (==1)) small
   ]
 ,  bgroup "big" [
     bench "length" $ whnf length big
   , bench "length . filter" $ whnf (length . filter (==1)) big
   ]
 ] ]
