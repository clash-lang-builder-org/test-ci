module VReverse where

import Clash.Prelude
import Clash.Explicit.Testbench

topEntity :: Vec 4 Int -> Vec 4 Int
topEntity = reverse
{-# NOINLINE topEntity #-}

testBench :: Signal System Bool
testBench = done
  where
    testInput      = pure (iterateI (+1) 1)
    expectedOutput = outputVerifier clk rst ((4:>3:>2:>1:>Nil):>Nil)
    done           = expectedOutput (topEntity <$> testInput)
    clk            = tbSystemClockGen (not <$> done)
    rst            = systemResetGen
