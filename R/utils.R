
#' @return holdings tbl
#'
#' @export
#'
filter_loudly <- function(x, ...){
  in_rows <- nrow(x)
  out <- filter(x, !!!treat_inputs_as_exprs(...))
  out_rows <- nrow(out)
  message("Filtered out ",in_rows-out_rows," rows.")
  return(out)
}


#' Date to Int
#'
#' @param date Specifies
#'
#' @return date in integer
#' @export
date_int <- function(date){
  ret <- lubridate::year(date)*10000 + lubridate::month(date)*100 + lubridate::day(date)

  ret <- as.integer(ret)

  return(ret)

}
