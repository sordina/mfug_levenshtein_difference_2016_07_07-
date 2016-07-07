
import Criterion
import Criterion.Main
import System.Environment

import qualified Lev1 as L1
import qualified Lev2 as L2
import qualified Lev3 as L3

setupEnv :: Int -> IO (String, String)
setupEnv s = do
  ws <- readFile "/usr/share/dict/words"
  return (take s ws, take s $ drop s ws)

main = do
  s <- getEnv "STRING_SIZE"
  defaultMain [
   env (setupEnv (read s)) $ \ ~(a, b) -> bgroup "main" [
     bgroup "string comparison" [
        bench "lazy-p" $ whnf (uncurry L3.score) (a, b)
      -- , bench "strict" $ whnf (uncurry L1.score) (a, b)
      -- , bench "lazy"   $ whnf (uncurry L2.score) (a, b)
      ] ] ]
