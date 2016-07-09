
import Criterion
import Criterion.Main
import System.Environment

import qualified Lev1 as L1
import qualified Lev2 as L2
import qualified Lev3 as L3

f t s (n, a, b) = bench (t ++ "--" ++ show n) $ nf (uncurry s) (a, b)

main = do
  ns    <- read <$> getEnv "STRING_SIZES" :: IO [Int]
  ws    <- readFile "/usr/share/dict/words"
  let xs = map (\n -> (n, take n ws, take n $ drop n ws)) ns

  defaultMain [
     bgroup "strict" (map (f "strict" L1.score) xs)
   , bgroup "lazy"   (map (f "lazy"   L2.score) xs)
   , bgroup "lazy_p" (map (f "lazy_p" L3.score) xs) ]
