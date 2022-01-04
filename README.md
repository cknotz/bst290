
# bst290

<!-- badges: start -->
<!-- badges: end -->

`bst290` is an `R` package developed for the [BST290](https://www.uis.no/nb/course/BST290_1) ("Kvantitativ forskningsmetode"/"Introduction to quantitative methods") course that is taught to BA Political Science ([BST](https://www.uis.no/nb/studietilbud/statsvitenskap-bachelor)) and BA Sociology ([B-SOSIOL](https://www.uis.no/nb/studieprogram-og-emner/sosiologi-bachelorstudium)) students at the University of Stavanger ([UiS](https://www.uis.no/en)), Norway.

The package includes:

* Functions to produce simple descriptive tables;
* An interactive Shiny dashboard featuring statistics exercises and illustrations of statistical distributions, the Central Limit Theorem, and confidence intervals;
* De-bugging exercises in the form of interactive `learnr` tutorials, in which students have to solve problems with incomplete or erroneous code chunks;
* A practice dataset, a subset of the *European Social Survey* (ESS) with a small number of respondents and variables;

**Important:** This is the first version. Everything important should work, but expect typos, weird formulations,...!

## Installation

You can install the development version of bst290 using this code:

``` r
# Requires devtools to install from Github
if(!require(devtools)){
  install.packages("devtools")
}

devtools::install_github("https://github.com/cknotz/bst290")
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
```

Creating a simple summary table using `mtcars`

``` r
oppsumtabell(dataset = mtcars,
             variables = c("cyl"))
```

Creating a cross table

``` r
krysstabell(dataset = mtcars,
            rowvar = "gear", colvar = "cyl")
```

Creating a summary table, by other variable

``` r
oppsum_grupp(dataset = mtcars,
          variable = "drat",
          by.var = "gear")
```
