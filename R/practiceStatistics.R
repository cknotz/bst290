#' An interactive dashboard featuring exercises & illustrations to practice statistical tests
#'
#' This function launches an interactive shiny-dashboard that allows users to practice calculating
#' and interpreting bivariate statistical tests (the t-test, the chi-squared test, and Pearson's
#' correlation coefficient). Users can let the dashboard generate random numbers to calculate test
#' statistics with. The dashboard also provides brief as well as detailed step-by-step solutions for
#' each type of test. In addition, the dashboard features a module to visualize statistical distributions
#' (the normal, t-, and chi-squared distributions) and critical values, a module to calculate p-values for
#' test statistics, a module to simulate the Central Limit Theorem, a module to illustrate the logic of
#' confidence intervals, and modules explaining fundamental materials such as mathematical concepts and
#' notation and the calculation of measures of central tendency (the mean and median) and dispersion
#' (the variance and standard deviation). The dashboard builds on (and can complement) Kellstedt & Whitten's
#' 'Fundamentals of Political Science Research' (Cambridge Univ. Press, 2018).
#'
#' @examples
#' \dontrun{
#' practiceStatistics()
#' }
#'
#' @export
practiceStatistics <- function() {
# Credit for this function belongs to Dean Atali (see https://deanattali.com/2015/04/21/r-package-shiny-app/)

appDir <- system.file("stats-dashboard",
                      package = "bst290")

  if(appDir==""){
    stop("Could not find the necessary files or folder. Please try re-installing the 'bst290' package.",
         call. = F)
  }


shiny::runApp(appDir,
              display.mode = "normal")

}
