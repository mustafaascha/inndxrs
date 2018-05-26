#' tdrActiveContext object.
#'
#' Functions for creating and displaying information about tdrActiveContext objects.
#'
#' @param x Object to create, test or print
#' @param ... Ignored
#'
#' @seealso [createTdrContext()]
#' @export
#' @rdname Internal
as.tdrActiveContext <- function(x){
  if(!is.environment(x)) stop("Expecting an environment as input")
  class(x) <- "tdrActiveContext"
  x
}

#' @export
#' @rdname Internal
is.tdrActiveContext <- function(x){
  inherits(x, "tdrActiveContext")
}

#' @export
print.tdrActiveContext <- function(x, ...){
  cat("inndxrs tdrActiveContext\n")
  cat("TDR Server :", x$server, "\n")
  cat("TDR Database :", x$database, "\n")
}

#' @export
str.tdrActiveContext <- function(object, ...){
  cat(("inndxrs tdrActiveContext with elements:\n"))
  ls.str(object, all.names = TRUE)
}

assertthat::on_failure(is.tdrActiveContext) <- function(call, env) {
  "Provide a valid tdrActiveContext. See createTdrContext()"
}
