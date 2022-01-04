#' Create a cross table showing column percentages
#'
#' This function allows you to cross-tabulate two variables in your dataset.
#' The table will show column percentages. The result can be printed in an
#' "export-ready" fashion, meaning it can be copied and pasted into a Word
#' document and there transformed into a publication-quality table. The
#' functions will provide warnings in some cases where user selections
#' might be problematic.
#'
#' @param dataset Your dataset (a data.frame-type object).
#' @param rowvar The row-variable.
#' @param colvar The column-variable.
#' @param export Should the result be made export-ready (TRUE/FALSE)?
#'
#' @return A matrix or, if export function is switched on (export=TRUE), a
#' printed out table formatted for easy export to MS Word.
#'
#' @examples
#' \dontrun{
#' # Load mtcars dataset
#' data(mtcars)
#'
#' # Simple example
#' krysstabell(dataset = mtcars,
#' rowvar = "carb",
#' colvar = "gear")
#'
#' # For export
#' krysstabell(dataset = mtcars,
#' rowvar = "carb",
#' colvar = "gear",
#' export = TRUE)
#' }
#'
#' @importFrom utils menu write.table
#' @importFrom stats addmargins
#'
#' @export
krysstabell <- function(dataset,rowvar,colvar,export=NULL){

  # Helper function (from shttps://stackoverflow.com/questions/14469522/stop-an-r-program-without-error)
  stop_quietly <- function() {
    opt <- options(show.error.messages = FALSE)
    on.exit(options(opt))
    stop()
  }

  # Warning & stop if variables do not exist
  nullcheck <- is.null(dataset[[rowvar]])
  if(nullcheck==T){
    warning(call. = F,
            "It seems your row-variable does not exist. Did you type its name correctly?")
    stop_quietly()
  }

  # Warning & stop if variables do not exist
  nullcheck <- is.null(dataset[[colvar]])
  if(nullcheck==T){
    warning(call. = F,
            "It seems your column-variable does not exist. Did you type its name correctly?")
    stop_quietly()
  }

  # Warning & stop if col & row vars are identical
  if(rowvar==colvar){
    warning("It seems your column and row variables are identical. Cross-tabulation does not really make sense here.",
            call. = F)
    stop_quietly()
  }

  # Warning & confirm for non-cat rowvars
  if(length(unique(dataset[[rowvar]]))>=10){
    response <- utils::menu(c("Yes","No"),
                            title = "WARNING: It looks like your row variable has 10 or more unique categories.\n Are you sure you want to use this variable in a cross table?")
    if(response==2){
      stop_quietly()
    }
  }

  # Warning & confirm for non-cat colvars
  if(length(unique(dataset[[colvar]]))>=10){
    response <- utils::menu(c("Yes","No"),
                            title = "WARNING: It looks like your column variable has 10 or more unique categories.\n Are you sure you want to use this variable in a cross table?")
    if(response==2){
      stop_quietly()
    }
  }


  if(is.null(export)){
    export <- FALSE
  }

  kryss <- table(dataset[[rowvar]],dataset[[colvar]])
  kryss <- cbind(kryss,apply(kryss,1,sum))

  kryss <- 100*prop.table(kryss,
                          margin = 2)

  kryss <- stats::addmargins(kryss, 1)
  colnames(kryss)[ncol(kryss)] <- "Sum"

  names(dimnames(kryss)) <- c(rowvar,colvar)
  kryss <- round(kryss, digits = 2)

  if(export==T){

    kryss <- format(kryss,digits=2,nsmall=2)

    carrymat <- rbind(rep(NA,ncol(kryss)),
                      rep(NA,ncol(kryss)),
                      kryss)
    carrymat[2,] <- colnames(kryss)
    carrymat[1,1] <- colvar
    carrymat <- cbind(c(NA,NA,rownames(kryss)),carrymat)
    carrymat[2,1] <- rowvar
    colnames(carrymat) <- NULL
    rownames(carrymat) <- NULL
    utils::write.table(carrymat,
                       quote = F, na = "", sep = ",", row.names = F, col.names = F)

  }else{
    return(kryss)
  }

}
