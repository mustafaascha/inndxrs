#' Reads settings from configuration file in JSON format.
#'
#' @param configFile location of file that contains configuration in JSON format. By default, this location is at `getOption("inndxrs.config")`
#' @export
#
read.inndxrs.config <- function(configFile = getOption("inndxrs.config")) {
  assertthat::assert_that(is.character(configFile))
  assertthat::assert_that(file.exists(configFile))
  z <- tryCatch(jsonlite::fromJSON(file(configFile)),
                error = function(e)e
  )
  # Error check the settings file for invalid JSON
  if(inherits(z, "error")) {
    msg <- sprintf("Your config file contains invalid json", configFile)
    msg <- paste(msg, z$message, sep = "\n\n")
    stop(msg, call. = FALSE)
  }
  z
}
