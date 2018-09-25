module Minimum where

import Clash.Prelude
import Clash.Explicit.Testbench

topEntity :: Vec 3 Int -> Int
topEntity = minimum
{-# NOINLINE topEntity #-}

testBench :: Signal System Bool
testBench = done
  where
    testInput      = pure (4 :> 8 :> (-2) :> Nil)
    expectedOutput = outputVerifier clk rst (singleton (-2))
    done           = expectedOutput (topEntity <$> testInput)
    clk            = tbSystemClockGen (not <$> done)
    rst            = systemResetGen
