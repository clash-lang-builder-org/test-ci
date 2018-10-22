module PortNames where

import qualified Prelude as P
import System.Environment (getArgs)
import System.FilePath ((</>))
import Text.Regex.PCRE ((=~))

import Clash.Prelude
import Clash.Explicit.Testbench

{-# ANN topEntity
  (Synthesize
    { t_name     = "PortNames_topEntity"
    , t_inputs   = [
        ]
    , t_output   = PortProduct "top" [
            PortName "zero",
            PortProduct "sub" [
              PortName "one",
              PortName "two"
            ]
        ]
    }) #-}
topEntity :: (Signal System Int, (Signal System Int, Signal System Int))
topEntity = (pure 0, (pure 1, pure 2))

-- Simulation test
{-# ANN testBench
  (Synthesize
    { t_name     = "PortNames_testBench"
    , t_inputs   = [ ]
    , t_output   = PortName "result"
    }) #-}
testBench :: Signal System Bool
testBench = done
  where
    expectedOutput = outputVerifier clk rst ((0, (1, 2)) :> (0, (1, 2)) :> Nil)
    done           = expectedOutput (bundle $ bundle <$> topEntity)
    clk            = tbSystemClockGen (not <$> done)
    rst            = systemResetGen

-- File content test
assertIn :: String -> String -> IO ()
assertIn needle haystack
  | haystack =~ needle = return ()
  | otherwise = P.error $ P.concat [ "Expected:\n\n  ", needle
                                   , "\n\nIn:\n\n", haystack ]

mainVerilog :: IO ()
mainVerilog = do
  [modDir, topFile] <- getArgs
  content <- readFile "verilog/PortNames/PortNames_topEntity/PortNames_topEntity.v"

  assertIn "top_zero" content
  assertIn "top_sub_one" content
  assertIn "top_sub_two" content
