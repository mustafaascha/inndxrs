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
  cat("TDR Server Name :", x$servername, "\n")
  cat("TDR Server URL :", x$serverurl, "\n")
  cat("TDR Database :", x$database, "\n")
  cat("TDR Connected :", x$connected, "\n")
}

#' @export
str.tdrActiveContext <- function(object, ...){
  cat(("inndxrs tdrActiveContext with elements:\n"))
  ls.str(object, all.names = TRUE)
}

assertthat::on_failure(is.tdrActiveContext) <- function(call, env) {
  "Provide a valid tdrActiveContext. See createTdrContext()"
}


# is_connected <- function(x) {
#   is.character(x) && length(x) == 1 && nchar(x) > 0
# }
#
# on_failure(is_admin_user) <- function(call, env) {
#   "Provide an adminUser"
# }

#' @export
#' @rdname Internal
as.obxActiveContext <- function(x){
  if(!is.environment(x)) stop("Expecting an environment as input")
  class(x) <- "obxActiveContext"
  x
}

#' @export
#' @rdname Internal
is.obxActiveContext <- function(x){
  inherits(x, "obxActiveContext")
}

#' @export
print.obxActiveContext <- function(x, ...){
  cat("inndxrs obxActiveContext\n")
  cat("Obx Company Name :", x$companyname, "\n")
}

#' @export
str.obxActiveContext <- function(object, ...){
  cat(("inndxrs obxActiveContext with elements:\n"))
  ls.str(object, all.names = TRUE)
}

assertthat::on_failure(is.obxActiveContext) <- function(call, env) {
  "Provide a valid obxActiveContext. See createObxContext()"
}
