# fire-number-calc

Fire number and timeline math for early retirement planning.

A fire number is annual spending divided by a withdrawal rate. The
honest version of the plan also counts the gap from today's balance to
that target and the years of saving it takes to close the gap when the
portfolio compounds at a fixed return.

The package follows the withdrawal-rate and sequence-of-returns math
published on [Firenomics](https://firenomics.com). It depends only on
base.

## Example

With $48,000 of annual spending at a 4% withdrawal rate:

* fire number: `fireNumber 48000 0.04` = $1,200,000
* gap from a $450,000 balance: `gapToTarget 450000 1200000` = $750,000
* years to close it saving $30,000 a year at a 6% return:
  `yearsToTarget 450000 30000 1200000 0.06 0` = 10 years
* the same plan with the spending budget growing 3% a year until
  retirement: 17 years

The last two numbers are the point. A budget that grows before
retirement pushes the crossing point out by seven working years in
this plan, and `budgetCost` returns both timelines so the comparison
is one call.
