-- | Fire number math for early retirement planning.
--
-- A fire number is annual spending divided by a withdrawal rate, and the
-- honest version of the plan also counts the gap from your current
-- balance, the years of saving it takes to close, and what happens to
-- that timeline when the spending budget grows before you retire.
module FireNumber.Calc
  ( fireNumber
  , gapToTarget
  , yearsToTarget
  , budgetCost
  ) where

-- | The balance a withdrawal rate has to support a given annual spending.
-- A zero or negative rate guards to zero.
fireNumber :: Double -> Double -> Double
fireNumber annualSpending withdrawalRate
  | withdrawalRate <= 0 = 0
  | otherwise           = annualSpending / withdrawalRate

-- | Dollars still missing between today's balance and the fire number.
-- Never negative.
gapToTarget :: Double -> Double -> Double
gapToTarget currentBalance target = max 0 (target - currentBalance)

-- | Whole years until the portfolio (balance plus annual saving,
-- compounding at 'returnRate') covers the fire number. The target itself
-- grows at 'spendingGrowth' each year, so a growing budget pushes the
-- crossing point out. Returns 0 when you are already there and positive
-- infinity when the budget outruns the savings forever.
yearsToTarget :: Double -> Double -> Double -> Double -> Double -> Double
yearsToTarget currentBalance annualSaving target returnRate spendingGrowth
  | currentBalance >= target = 0
  | otherwise                = go (1 :: Int)
  where
    go n
      | n > 600   = 1 / 0
      | bal >= tgt = fromIntegral n
      | otherwise = go (n + 1)
      where
        grow = (1 + returnRate) ** fromIntegral n
        bal  = currentBalance * grow
             + if returnRate > 0
                 then annualSaving * (grow - 1) / returnRate
                 else annualSaving * fromIntegral n
        tgt  = target * (1 + spendingGrowth) ** fromIntegral n

-- | Both timelines: years to the target with a flat budget and with one
-- that grows each year until retirement. The difference is the price of
-- the growing budget in working years.
budgetCost :: Double -> Double -> Double -> Double -> Double -> (Double, Double)
budgetCost currentBalance annualSaving target returnRate spendingGrowth =
  ( yearsToTarget currentBalance annualSaving target returnRate 0
  , yearsToTarget currentBalance annualSaving target returnRate spendingGrowth
  )
