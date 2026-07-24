# Structured Products and Fourier Option Pricing in MATLAB

This repository contains MATLAB implementations for structured-product valuation,
Fourier-based option pricing, Monte Carlo simulation, and implied-volatility
surface calibration.

The project studies both standard and non-Gaussian pricing frameworks, with
particular emphasis on the numerical implementation of the Lewis formula,
Fast Fourier Transform methods, and normal mean-variance mixture models.

The reference valuation date is 15 February 2008.

## Project Overview

The project covers four main areas:

- pricing of a basket-linked structured product;
- digital option valuation under an implied-volatility smile;
- option pricing through Fourier inversion and Monte Carlo simulation;
- calibration of a non-Gaussian model to an implied-volatility surface.

The main objective is to compare alternative numerical techniques and assess
their accuracy, stability, and computational efficiency.

## Structured Certificate Pricing

The first case study considers a structured certificate issued by a bank and
hedged through an OTC swap.

The derivative payoff is linked to an equally weighted basket composed of:

- ENI;
- AXA.

The valuation incorporates:

- basket correlation;
- individual equity volatilities;
- dividend yields;
- discount factors;
- capital protection;
- participation in the positive basket performance.

The project determines the upfront payment required to make the transaction fair
under mid-market conditions.

The valuation is performed in a single-curve framework, assuming deterministic
interest rates and neglecting counterparty credit risk under a collateralised
ISDA/CSA agreement.

## Basket Simulation

The terminal values of the two equity underlyings are simulated under correlated
risk-neutral dynamics.

Correlated Gaussian shocks are generated through a covariance decomposition:

\[
Z = L \varepsilon,
\]

where \(L\) is obtained from the correlation matrix and \(\varepsilon\) is a
vector of independent standard normal random variables.

The simulated basket performance is then used to estimate the expected structured
payoff and the corresponding fair upfront.

## Digital Option Pricing and Volatility Smile

The project compares the value of a digital option under two approaches:

1. Black pricing with a single implied volatility;
2. pricing consistent with the complete implied-volatility smile.

A digital call has payoff

\[
\Pi_T = Q\,\mathbf{1}_{\{S_T>K\}},
\]

where \(Q\) is the contractual cash payment.

Under the Black model, the price is

\[
V_0 = B(0,T)\,Q\,N(d_2).
\]

However, digital options are particularly sensitive to the local slope of the
implied-volatility smile. For this reason, using only the volatility associated
with the strike may produce a material pricing error.

The smile-adjusted digital value is obtained from the strike derivative of the
vanilla call-price curve:

\[
V_{\text{digital}}(K)
=
-\frac{\partial C(K)}{\partial K}.
\]

The numerical implementation therefore reconstructs a sufficiently smooth call
price curve and estimates the derivative with respect to strike.

## Lewis-Fourier Option Pricing

The project implements option pricing under a model specified through its
characteristic function.

For a European call, the price is recovered through the Lewis Fourier-inversion
formula. The characteristic function is evaluated on a shifted contour in the
complex plane to ensure integrability and numerical stability.

The implementation compares four approaches:

- direct numerical quadrature;
- residue-based analytical or semi-analytical evaluation;
- Monte Carlo simulation;
- Fast Fourier Transform.

This comparison allows the accuracy and computational cost of the different
methods to be assessed.

## Numerical Quadrature

The Fourier integral is evaluated directly through adaptive numerical integration.

This method provides a useful benchmark because it avoids the discretisation
structure imposed by the FFT grid.

Its main advantages are:

- direct control of the integration tolerance;
- flexibility across strikes;
- straightforward implementation.

Its main limitation is computational cost when a large number of strikes must be
priced.

## Residue-Based Pricing

When the characteristic function has a sufficiently simple meromorphic structure,
the Fourier integral may be evaluated through the residue theorem.

The implementation identifies the relevant poles of the integrand and computes
the corresponding residues.

This approach provides an analytical benchmark for validating the numerical
quadrature and FFT results.

## Monte Carlo Pricing

Monte Carlo simulation is used as an independent pricing benchmark.

The procedure consists of:

1. simulating terminal returns under the selected model;
2. reconstructing the terminal underlying price;
3. computing the discounted option payoff;
4. estimating the standard error and confidence interval.

For a European call,

\[
C_0
=
B(0,T)
\mathbb{E}
\left[
(S_T-K)^+
\right].
\]

The Monte Carlo estimator is compared with Fourier-based prices to verify the
consistency of the model simulation.

## Fast Fourier Transform

The FFT implementation computes option prices over a complete strike grid in a
single numerical operation.

The main numerical parameters include:

- number of grid points;
- Fourier-domain spacing;
- log-strike spacing;
- integration truncation range;
- complex contour shift.

The project studies how the selection of these parameters affects:

- truncation error;
- discretisation error;
- strike-grid resolution;
- computational time;
- numerical oscillations.

The FFT results are compared against quadrature and Monte Carlo benchmarks.

## Normal Inverse Gaussian Model

The project also considers a normal mean-variance mixture model with
\(\alpha = 1/2\), corresponding to a Normal Inverse Gaussian-type specification.

The model introduces non-Gaussian features such as:

- skewness;
- excess kurtosis;
- heavier tails;
- a non-flat implied-volatility smile.

European call prices are computed over a moneyness grid using:

- FFT;
- numerical quadrature;
- Monte Carlo simulation.

The Monte Carlo implementation simulates the mixing variable and the conditional
Gaussian component separately.

The first four numerical moments of the simulated distribution are compared with
their analytical counterparts as a validation check.

## Comparison of Pricing Methods

The pricing methods are compared in terms of:

- absolute pricing differences;
- convergence;
- numerical stability;
- execution time;
- sensitivity to grid parameters;
- Monte Carlo confidence intervals.

Quadrature is used as a high-accuracy pointwise benchmark, while FFT is particularly
efficient when prices are required for many strikes simultaneously.

Monte Carlo provides an independent probabilistic validation but converges at the
standard rate

\[
O\left(N^{-1/2}\right).
\]

## Implied-Volatility Surface Calibration

The final section calibrates a non-Gaussian model to an S&P 500 implied-volatility
surface.

The calibration is global across strikes and maturities and uses constant weights.

Let \(\theta\) denote the model parameters. The calibration problem is formulated as

\[
\widehat{\theta}
=
\arg\min_{\theta}
\sum_{i=1}^{N}
\left(
\sigma^{\text{model}}_i(\theta)
-
\sigma^{\text{market}}_i
\right)^2.
\]

For each candidate parameter set:

1. model option prices are computed;
2. prices are converted into implied volatilities;
3. model and market volatilities are compared;
4. the objective function is minimised numerically.

The calibrated surface is then plotted against the market implied-volatility
surface to evaluate the quality of fit.

## Code Structure

The Fourier-pricing code is organised into three layers:

1. a main script controlling inputs, execution, and plots;
2. pricing functions implementing FFT, quadrature, residues, and Monte Carlo;
3. lower-level functions evaluating characteristic functions and Fourier integrands.

A representative structure is:

```text
runPricingFourier.m
│
├── priceCallFFT.m
├── priceCallQuadrature.m
├── priceCallMonteCarlo.m
├── priceCallResidues.m
├── pricingIntegrand.m
└── modelCharacteristicFunction.m
