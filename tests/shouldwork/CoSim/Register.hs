{-# LANGUAGE ViewPatterns #-}
module Register where

import Clash.CoSim
import Clash.Explicit.Prelude

verilog_register
  :: Clock  d 'Source
  -> Reset  d 'Asynchronous
  -> Signal d (Signed 64)
  -> Signal d (Signed 64)
verilog_register clk (unsafeFromAsyncReset -> arst) x = [verilog|
  parameter data_width = 64;

  input  #{clk};
  input  [0:0] ${arst};
  input  signed [0:data_width-1] ${x};
  output reg signed [0:data_width-1] result;

    always @(posedge(#{clk}) or posedge(${arst})) begin
      if (${arst} == 1'b1) begin
        result <= 0;
      end else begin
        result <= ${x};
      end
    end
  |]
{-# NOINLINE verilog_register #-}

topEntity
  :: Clock System 'Source
  -> Reset System 'Asynchronous
  -> Signal System (Signed 64)
topEntity clk arst = let s  = verilog_register clk arst (s' + 1)
                         s' = register clk arst 0 s
                     in  s'

testBench :: Signal System Bool
testBench = done
 where
  done = outputVerifier clk aclr (0:>0:>1:>1:>2:>2:>3:>3:>4:>4:>Nil) res
  res  = topEntity clk aclr
  clk  = tbSystemClockGen (not <$> done)
  aclr = systemResetGen
