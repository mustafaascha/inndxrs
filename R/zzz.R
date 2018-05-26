# list all global variables
globalVariables(".")

inndxrs.config.default <- ifelse(Sys.info()["sysname"] == "Windows",
                                  paste0("C:/Users/", Sys.getenv("USERNAME"), "/.inndxrs/config.json"),
                                  "~/.inndxrs/config.json")

.onAttach <- function(libname, pkgname) {
  if (is.null(getOption("inndxrs.config")))
    options(inndxrs.config = inndxrs.config.default)
}
