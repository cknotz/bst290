#' Show value-label correspondence for factor variables
#'
#' This function shows you how the text labels and underlying numerical
#' values of a given factor-type variable correspond. You can use this
#' function in two ways: 1) in its default setting, the function returns
#' a simple table (more accurately, a data.frame) where each row is a
#' unique value of the factor variable. The table shows how numerical
#' values and text labels correspond. 2) You can choose the 'detail'
#' view, in which case the function prints out a table in which the
#' rows are actual observations from your dataset and shows you how
#' the factor variable's numerical values and text labels correspond
#' in your dataset. You can choose how many rows of the dataset are
#' printed, but the default is 15.
#' @param dataset Your dataset (a data.frame-type object).
#' @param variable The variable from your dataset for which you want
#' summary statistics. Specify it as a string (e.g., "gndr").
#' @param detail Do you want to get the 'detail' view (TRUE/FALSE)?
#' @param nrows How many rows do you want to get printed out if you
#' choose the detail-view (detail=TRUE). Must be a number.
#'
#' @return A data.frame.
#'
#'@examples
#' \dontrun{
#' # Loading dataset
#' data(ess, package = "bst290")
#'
#' # Default view
#' visfactor(dataset = ess, variable = "gndr")
#'
#' # Detailed view
#' visfactor(dataset = ess, variable = "gndr", detail = TRUE)
#'
#' # Detailed view, with 25 instead of 15 rows printed
#' visfactor(dataset = ess, variable = "gndr", detail = TRUE, nrows = 25)
#' }
#'
#' @importFrom utils head
#'
#' @export
visfactor <- function(variable,dataset,detail=NULL,nrows=NULL){

  # Acknowledgement: This function is based on this thread on stackoverflow: https://stackoverflow.com/questions/24860478/show-mapping-of-factor-levels-and-factor-values-in-r

  # Helper function (from shttps://stackoverflow.com/questions/14469522/stop-an-r-program-without-error)
  stop_quietly <- function() {
    opt <- options(show.error.messages = FALSE)
    on.exit(options(opt))
    stop()
  }

  # Check if dataset is tibble, convert to data.frame if yes
  if(class(dataset)[1]=="tbl_df"){
    newset <- as.data.frame(dataset)
  }else{
    newset <- dataset
  }

  # Check if is.factor, stop otherwise
  if(!is.factor(newset[,c(variable)])){
    warning("It looks like your variable is not a factor. This function only works with factor-type variables.\n Use class() to check if your variable is a factor. For example: class(ess$vote)")
    stop_quietly()
  }

  if(is.null(detail)){
    detail = F
  }

  if(is.null(nrows)){
    nrows = 15
  }

  if(detail==F){
    return(data.frame(values = seq_along(levels(newset[,c(variable)])),
                      labels = levels(newset[,c(variable)])))
  }else{
    head(data.frame(original = newset[,c(variable)],
                    labels = as.character(newset[,c(variable)]),
                    values = as.numeric(newset[,c(variable)])), nrows)
  }
}
