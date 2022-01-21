
# bst290

<!-- badges: start -->
<!-- badges: end -->

`bst290` is an `R` package developed for the [BST290](https://www.uis.no/nb/course/BST290_1) ("Kvantitativ forskningsmetode"/"Introduction to quantitative methods") course that is taught to BA Political Science ([BST](https://www.uis.no/nb/studietilbud/statsvitenskap-bachelor)) and BA Sociology ([B-SOSIOL](https://www.uis.no/nb/studieprogram-og-emner/sosiologi-bachelorstudium)) students at the University of Stavanger ([UiS](https://www.uis.no/en)), Norway.

The package includes:

* Functions to produce simple descriptive tables;
* An interactive `Shiny` dashboard featuring statistics exercises and illustrations of statistical distributions, the Central Limit Theorem, and confidence intervals;
* De-bugging exercises in the form of interactive `learnr` tutorials, in which students have to solve problems with incomplete or erroneous code chunks;
* A practice dataset, a subset of the *European Social Survey*<sup>[1]</sup> dataset, including a small number of respondents and variables;


## Installation

You can install the current version of `bst290` using the following code:

``` r
# Requires devtools to install from Github
if(!require(devtools)){
  install.packages("devtools")
}

devtools::install_github("cknotz/bst290")
```

## Examples

This is how the interactive dashboard with statistics exercises is launched:

``` r
library(bst290)

practiceStatistics()
```

Loading the included practice dataset:

``` r
data(ess)

# Alternative:
ess <- bst290::ess
```

A simple summary table:

``` r
oppsumtabell(dataset = ess,
             variables = c("agea","weight","height"))
```

A cross table:

``` r
krysstabell(dataset = ess,
            rowvar = "gndr",
            colvar = "vote")
```

A summary table, stats by other variable:

``` r
oppsum_grupp(dataset = ess,
             variable = "height",
             by.var = "gndr")
```

## De-bugging tutorials

To access the `learnr` tutorials, navigate to the *Tutorial* tab in **RStudio** (upper-right corner of the screen) and look for "De-bugging exercises". You may have to install the `learnr`-package, but **RStudio** should help you with that.

## References

[1] ESS Round 7: European Social Survey Round 7 Data (2014). Data file edition 2.2. NSD - Norwegian Centre for Research Data, Norway – Data Archive and distributor of ESS data for ESS ERIC. [doi:10.21338/NSD-ESS7-2014](http://dx.doi.org/10.21338/NSD-ESS7-2014). Licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).
