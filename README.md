
# bst290

<!-- badges: start -->
<!-- badges: end -->

`bst290` is an `R` package developed for the BST290 ("Kvantitativ forskningsmetode"/"Introduction to quantitative methods") course that is taught to BA Political Science (BST) and BA Sociology (BSS) students at the University of Stavanger (UiS), Norway.

The package includes:

* Functions to produce simple descriptive tables;
* An interactive Shiny dashboard featuring statistics exercises and illustrations of statistical distributions, the Central Limit Theorem, and confidence intervals;
* De-bugging exercises in the form of interactive `learnr` tutorials, in which students have to solve problems with incomplete or erroneous code chunks;
* A practice dataset, a subset of the *European Social Survey* (ESS) with a small number of respondents and variables;

**Important:** This is the first version. Everything important should work, but expect typos, weird formulations,...!

## Installation

You can install the development version of bst290 like so:

``` r
# Requires devtools to install from Github
if(!require(devtools)){
  install.packages("devtools")
}

devtools::install_github()
```

## Examples

This is how the interactive dashboard with statistics exercises is launched:

``` r
library(bst290)
practiceStatistics()
```

Loading the included practice dataset:

``` r 
library(bst290)

data(ess)
```
