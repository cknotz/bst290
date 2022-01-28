#' Create univariate summary tables
#'
#' This function allows you to create a simple univariate summary table for one
#' or more variables in a dataset. The table will show the following summary
#' statistics: the number of non-missing observations, the average (mean),
#' the median, the 25th and 75th percentiles, the standard deviation, the
#' minimum, the maximum, and the number of missing observations.
#'
#' The result can be printed in an "export-ready" fashion, meaning
#' it can be copied and pasted into a Word document and there transformed into
#' a publication-quality table. The function will provide warnings in some
#' cases where user selections might be problematic.
#'
#' @param dataset Your dataset (a data.frame-type object).
#' @param variables The variables from your dataset for which you want
#' summary statistics. Specify them as a string or a string vector.
#' @param variable Alias for `variables`. One of `variable` or `variables` must
#' be used.
#' @param export Should the table be made export-ready (TRUE/FALSE)?
#'
#' @return A data.frame or, if export function is switched on (export=TRUE), a
#' printed out table formatted for easy export to MS Word.
#'
#' @examples
#' \dontrun{
#' # Loading mtcars dataset
#' data(mtcars)
#'
#' # For a single variable
#' oppsumtabell(dataset = mtcars, variables = c("cyl"))
#'
#' # Alternative
#' oppsumtabell(dataset = mtcars, variables = "cyl")
#'
#' # For more variables
#' oppsumtabell(dataset = mtcars,
#' variables = c("cyl","mpg","disp"))
#'
#' # Using export function
#' oppsumtabell(dataset = mtcars,
#'  variables = "mpg", export = TRUE)
#' }
#'
#' @importFrom stats sd median quantile
#' @importFrom utils write.table
#'
#' @export
oppsumtabell <- function(dataset,variables=NULL,export=NULL,variable=NULL) {

  # Helper function (from https://stackoverflow.com/questions/14469522/stop-an-r-program-without-error)
  stop_quietly <- function() {
    opt <- options(show.error.messages = FALSE)
    on.exit(options(opt))
    stop()
  }

  # Aliasing variable & variables
  if(is.null(variables) & !is.null(variable)){
    variables <- variable
    variable <- NULL
  }

  if(is.null(variables) & is.null(variable)){
    warning(call. = F,
            "You need to specify one more variables that you want to get summary statistics for! See also '?oppsumtabell' for help.")
    stop_quietly()
  }

  # Labels
  stats <- c("Observations","Average","25th percentile","Median","75th percentile",
             "Stand. Dev.","Minimum","Maximum","Missing")

  # Set default
  if(is.null(export)){
    export <- FALSE
  }

  if(length(variables)>1){

    # check & stop if user selects non-existing variable(s)
    nullchecks <- rep(NA,length(variables))

    for(x in 1:length(variables)){
      nullchecks[x] <- is.null(dataset[[variables[x]]])
    }
    check <- TRUE %in% nullchecks
    if(check==TRUE){
      warning(call. = F,
              "It seems you selected one or more variables that do not exist. Perhaps a typo?")
      stop_quietly()
    }

    # check & stop if user selects character variable
    numcheck <- sapply(dataset[,variables],is.character)
    check <- TRUE %in% numcheck
    if(check==TRUE){
      warning(call. = F,
              "It seems you selected one or more character variables. This does not make sense here. (Maybe one of your variables has been converted to text?)")
      stop_quietly()
    }

    # check & stop if user selects logical
    numcheck <- sapply(dataset[,variables],is.logical)
    check <- TRUE %in% numcheck
    if(check==TRUE){
      warning(call. = F,
              "It seems you selected one or more logical (TRUE/FALSE) variables. This does not make sense here. Are you sure you have the right variables?")
      stop_quietly()
    }

    # check & convert factors
    numcheck <- sapply(dataset[,variables],is.factor)
    check <- TRUE %in% numcheck
    if(check==TRUE){
      warning(call. = F,
              "It seems one or more of your variables are factors (how categorical or ordinal variables should be saved in R). These were automatically converted to numeric variables. You should THINK CAREFULLY: Does it make sense to calculate summary statistics for them? And could some of them really be numeric variables that happen to be saved as factors?")
      checkdat <- as.data.frame(lapply(dataset[,variables],function(x){
        if(is.factor(x)){
          x <- as.numeric(x)
        }else{
          x <- x
        }
      }))
    }else{
      checkdat <- dataset
    }


    means <- apply(checkdat[,variables],2,mean,na.rm = T)
    sds <- apply(checkdat[,variables],2,stats::sd,na.rm = T)
    maxs <- apply(checkdat[,variables],2,max,na.rm = T)
    mins <- apply(checkdat[,variables],2,min,na.rm = T)
    medians <- apply(checkdat[,variables],2,stats::median,na.rm = T)
    q25s <- apply(checkdat[,variables],2,FUN = function(x){
      stats::quantile(x,.25,na.rm = T)
    })
    q75s <- apply(checkdat[,variables],2,FUN = function(x){
      stats::quantile(x,.75,na.rm = T)
    })
    nas <- apply(checkdat[,variables],2,FUN = function(x){
      sum(is.na(x))
    })
    obs <- apply(checkdat[,variables],2,FUN = function(x){
      sum(!is.na(x))
    })

    sumtab <- round(t(cbind(obs,means,q25s,medians,q75s,sds,mins,maxs,nas)),digits = 2)
    #rownames(sumtab) <- stats

    # Tidy data.frame
    sumtab.df <- as.data.frame(sumtab)
    sumtab.df <- cbind(stats,sumtab.df)
    rownames(sumtab.df) <- NULL
    colnames(sumtab.df) <- c("Variable",variables)

    # Regular export
    if(export==T){
      return(utils::write.table(format(sumtab.df,digits=2,nsmall=2),
                                quote = F,
                                sep = ",",
                                na = "",
                                row.names = F))
    }else{
      print(sumtab.df, row.names=F, right=F)
    }
  }
  else if(length(variables)==1){

    # Warning & stop if variables do not exist
    nullcheck <- is.null(dataset[[variables]])
    if(nullcheck==T){
      warning(call. = F,
              "It seems you selected variables that do not exist. Perhaps a typo?")
      stop_quietly()
    }

    # check & stop if user selects character variable
    numcheck <- is.character(dataset[[variables]])
    if(numcheck==TRUE){
      warning(call. = F,
              "It seems you selected one or more character variables. This does not make sense here. (Maybe one of your variables has been converted to text?)")
      stop_quietly()
    }

    # check & stop if user selects logical
    numcheck <- is.logical(dataset[[variables]])
    if(numcheck==TRUE){
      warning(call. = F,
              "It seems you selected one or more logical (TRUE/FALSE) variables. This does not make sense here. Are you sure you have the right variables?")
      stop_quietly()
    }

    # check & convert factors
    numcheck <- is.factor(dataset[[variables]])
    if(numcheck==TRUE){
      warning(call. = F,
              "It seems one or more of your variables are factors (how categorical or ordinal variables should be saved in R). These were automatically converted to numeric variables. You should THINK CAREFULLY: Does it make sense to calculate summary statistics for them? And could some of them really be numeric variables that happen to be saved as factors?")
      checkdat <- dataset
      checkdat[[variables]] <- as.numeric(checkdat[[variables]])
    }else{
      checkdat <- dataset
    }

    means <- mean(checkdat[[variables]],na.rm=T)
    sds <- stats::sd(checkdat[[variables]],na.rm=T)
    maxs <- max(checkdat[[variables]],na.rm=T)
    mins <- min(checkdat[[variables]],na.rm=T)
    medians <- stats::median(checkdat[[variables]],na.rm=T)
    q25s <- stats::quantile(checkdat[[variables]],.25,
                            na.rm = T)
    q75s <- stats::quantile(checkdat[[variables]],.75,
                            na.rm = T)
    nas <- sum(is.na(checkdat[[variables]]))
    obs <- sum(!is.na(checkdat[[variables]]))

    sumtab <- round(t(cbind(obs,means,q25s,medians,q75s,sds,mins,maxs,nas)),
                    digits = 2)

    # Tidy data.frame
    sumtab.df <- as.data.frame(sumtab)
    sumtab.df <- cbind(stats,sumtab.df)
    rownames(sumtab.df) <- NULL
    colnames(sumtab.df) <- c("Variable",variables)

    # Regular export
    if(export==T){
      return(utils::write.table(format(sumtab.df,digits=2,nsmall=2),
                                quote = F,
                                sep = ",",
                                na = "",
                                row.names = F))
    }else{
      print(sumtab.df, row.names=F, right=F)
    }
  }

}
