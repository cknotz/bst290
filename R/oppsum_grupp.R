#' Create a summary table for one variable grouped by another variable
#'
#' This function allows you to create a table with summary statistics for one
#' variable over groups defined by another variable. The table will show the
#' following summary statistics: the number of nonmissing observations, the
#' average (mean), the median, the 25th and 75th percentiles, the standard
#' deviation, the minimum, the maximum, and the number of missing observations.
#'
#' The result can be printed in an "export-ready" fashion, meaning
#' it can be copied and pasted into a Word document and there transformed into
#' a publication-quality table. The function will provide warnings in some
#' cases where user selections might be problematic.
#'
#' @param dataset Your dataset (a data.frame-type object).
#' @param variable The variable for which you want summary statistics
#' (should ideally be a numeric variable).
#' @param by.var The variable that defines the groups over which the statistics
#' are calculated (should ideally be a categorical variable with not more than
#' 10 unique categories).
#' @param export Should the result be made export-ready (TRUE/FALSE)?
#'
#' @param norsk Results in Norwegian (NB)?
#'
#' @return A data.frame or, if export function is switched on (export=TRUE), a
#' printed out table formatted for easy export to MS Word.
#'
#' @examples
#' \dontrun{
#' # Load mtcars
#' data(mtcars)
#'
#' # Simple
#' oppsum_grupp(dataset = mtcars,
#' variable = "drat",
#' by.var = "gear")
#'
#' # With export function
#' result <- oppsum_grupp(dataset = mtcars,
#' variable = "mpg",
#' by.var = "cyl",
#' export = TRUE)
#' }
#'
#' @importFrom utils menu write.table
#' @importFrom stats aggregate median quantile sd
#'
#'
#' @export
oppsum_grupp <- function(dataset,variable,by.var,export=NULL,norsk=NULL){

  # Helper function
  stop_quietly <- function() {
    opt <- options(show.error.messages = FALSE)
    on.exit(options(opt))
    stop()
  }


  # Warning & stop if variables do not exist
  nullcheck <- is.null(dataset[[variable]])
  if(nullcheck==T){
    warning(call. = F,
            "It seems the variable for which you want summary statistics does not exist. Did you type its name correctly?")
    stop_quietly()
  }

  nullcheck <- is.null(dataset[[by.var]])
  if(nullcheck==T){
    warning(call. = F,
            "It seems your 'by'-variable does not exist. Did you type its name correctly?")
    stop_quietly()
  }


  # Warning & stop if col & row vars are identical
  if(variable==by.var){
    warning("It seems you are trying to tabulate a variable by itself. This does not make sense.",
            call. = F)
    stop_quietly()
  }

  # check & stop if user selects character variable
  numcheck <- is.character(dataset[[variable]])
  if(numcheck==TRUE){
    warning(call. = F,
            "It seems you selected a character variable. This does not make sense here. (Maybe your variable has been converted to text?)")
    stop_quietly()
  }

  # check & stop if user selects logical
  numcheck <- is.logical(dataset[[variable]])
  if(numcheck==TRUE){
    warning(call. = F,
            "It seems you selected a logical (TRUE/FALSE) variable. This does not make sense here. Are you sure you have the right variable?")
    stop_quietly()
  }

  # check & convert factors
  numcheck <- is.factor(dataset[[variable]])
  if(numcheck==TRUE){
    warning(call. = F,
            "It seems your variable is a factor (how categorical or ordinal variables should be saved in R). It was automatically converted to a numeric variable. You should THINK CAREFULLY: Does it make sense to calculate summary statistics for this variable? And might it really be a numeric variable that happens to be saved as a factor?")
    checkdat <- dataset
    checkdat[[variable]] <- as.numeric(checkdat[[variable]])
  }else{
    checkdat <- dataset
  }

  # Warning & confirm for non-cat by.var
  if(length(unique(checkdat[[by.var]]))>=10){
    response <- utils::menu(c("Yes","No"),
                            title = "WARNING: It looks like your 'by'-variable has 10 or more unique categories. Are you sure you want to proceed?")
    if(response==2){
      stop_quietly()
    }
  }

  # Set default
  if(is.null(export)){
    export <- FALSE
  }

  # Convert haven_labelled to regular data.frame
  if(class(checkdat)[1]=="tbl_df"){
    dataset2 <- as.data.frame(lapply(checkdat,
                                     FUN = function(x){
                                       attributes(x) <- NULL; x
                                     }))
  }else{
    dataset2 <- checkdat
  }

  avg <- stats::aggregate(dataset2[[variable]],
                          by = list(dataset2[[by.var]]),
                          FUN = function(x){
                            mean(x, na.rm = T)
                          })
  colnames(avg)[2] <- "avg"

  sd <- stats::aggregate(dataset2[[variable]],
                         by = list(dataset2[[by.var]]),
                         FUN = function(x){
                           stats::sd(x, na.rm = T)
                         })
  colnames(sd)[2] <- "sd"

  med <- stats::aggregate(dataset2[[variable]],
                          by = list(dataset2[[by.var]]),
                          FUN = function(x){
                            stats::median(x, na.rm = T)
                          })
  colnames(med)[2] <- "median"

  q25 <- stats::aggregate(dataset2[[variable]],
                          by = list(dataset2[[by.var]]),
                          FUN = function(x){
                            stats::quantile(x, probs = c(.25),
                                            na.rm = T)
                          })
  colnames(q25)[2] <- "q25"

  q75 <- stats::aggregate(dataset2[[variable]],
                          by = list(dataset2[[by.var]]),
                          FUN = function(x){
                            stats::quantile(x, probs = c(.75),
                                            na.rm = T)
                          })
  colnames(q75)[2] <- "q75"

  min <- stats::aggregate(dataset2[[variable]],
                          by = list(dataset2[[by.var]]),
                          FUN = function(x){
                            min(x, na.rm = T)
                          })
  colnames(min)[2] <- "min"


  max <- stats::aggregate(dataset2[[variable]],
                          by = list(dataset2[[by.var]]),
                          FUN = function(x){
                            max(x, na.rm = T)
                          })
  colnames(max)[2] <- "max"

  nas <- stats::aggregate(dataset2[[variable]],
                          by = list(dataset2[[by.var]]),
                          FUN = function(x){
                            sum(is.na(x))
                          })
  colnames(nas)[2] <- "NAs"

  obs <- stats::aggregate(dataset2[[variable]],
                          by = list(dataset2[[by.var]]),
                          FUN = function(x){
                            sum(!is.na(x))
                          })
  colnames(nas)[2] <- "obs"


  bytabell <- merge(obs,avg,
                    by = "Group.1")
  bytabell <- merge(bytabell,sd,
                    by = "Group.1")
  bytabell <- merge(bytabell,q25,
                    by = "Group.1")
  bytabell <- merge(bytabell,med,
                    by = "Group.1")
  bytabell <- merge(bytabell,q75,
                    by = "Group.1")
  bytabell <- merge(bytabell,min,
                    by = "Group.1")
  bytabell <- merge(bytabell,max,
                    by = "Group.1")
  bytabell <- merge(bytabell,nas,
                    by = "Group.1")

  rm(avg,sd,med,q25,q75,min,max,nas,obs)

  # Pretty output
  if(isTRUE(norsk)){
    colnames(bytabell) <- c(by.var,"Observasjoner","Gjennomsnitt","25. persentil","Median",
                            "75. persentil","Standardavvik","Minimum","Maksimum","Manglende")
  }else{
    colnames(bytabell) <- c(by.var,"Observations",
                            "Average","Stand. Dev.","25th percentile",
                            "Median","75th percentile","Minimum","Maximum",
                            "Missing")
  }

  if(export==T){
    return(utils::write.table(format(bytabell,digits=2,nsmall=2),
                              quote = F,
                              sep = ",",
                              na = "",
                              row.names = F))
  }else{
    print(format(bytabell,digits=2,nsmall=2), row.names=F, right=F,
          quote = F)
  }

}
