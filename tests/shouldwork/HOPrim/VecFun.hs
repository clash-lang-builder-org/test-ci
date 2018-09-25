module VecFun where

import Clash.Prelude
import Clash.Explicit.Testbench

topEntity = work
{-# NOINLINE topEntity #-}

work :: Vec 3 Int -> Vec 3 Int
work xs = zipWith sel xs funs where
    funs    = fun:>fun:>fun:>Nil
    fun x   = x + 1
    sel x f = f x

testBench :: Signal System Bool
testBench = done
  where
    testInput      = pure (1:>2:>3:>Nil)
    expectedOutput = outputVerifier clk rst ((2:>3:>4:>Nil):>Nil)
    done           = expectedOutput (topEntity <$> testInput)
    clk            = tbSystemClockGen (not <$> done)
    rst            = systemResetGen
