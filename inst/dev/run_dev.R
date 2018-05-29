# This script allow you to quick clean your R session
# update documentation and NAMESPACE, localy install the package
# and run the main shinyapp from 'inst/app'
.rs.api.documentSaveAll() # close and save all open file
suppressWarnings(lapply(paste('package:',names(sessionInfo()$otherPkgs),sep=""),detach,character.only=TRUE,unload=TRUE))
rm(list=ls(all.names = TRUE))
devtools::document(".")
devtools::load_all(".")
options(app.prod=FALSE) # TRUE = production mode, FALSE = development mode

shiny::runApp('inst/app')



packages <- paste0(
  crayon::green(cli::symbol$tick), " ", crayon::blue(format(to_load)), " ",
  crayon::col_align(versions, max(crayon::col_nchar(versions)))
)

st <- paste0(crayon::green(cli::symbol$warning), " ", " Test")

msg(st)

#
ac <- inndxrs:::createTdrContext(configFile = getOption("inndxrs.config"), svrname = "Azure")
servers <- tibble::as_tibble(ac$tdrservers)
#
#
# cpyname <- "Liberty"
# obxdbs <- ac$companies %>% dplyr::filter(CompanyName ==  cpyname)
#
#
# inndxrs:::createObxContext(tdrActiveContext = ac, cpyname = cpyname)
#
#
# companies <- ac$companies %>% dplyr::collect()
#
# if(nrow(companies) > 0){
#   obxdbs <- companies %>% dplyr::filter(CompanyName ==  cpyname)
# }
#
#
# if(nrow(obxdbs) >= 1){
#
#   obxdbs <- obxdbs %>%
#     dplyr::mutate(
#       serverurl = ac$serverurl,
#       uid = ac$uid,
#       pwd = ac$pwd,
#       driver = ac$driver,
#       port = ac$port
#     ) %>%
#     dplyr::group_by(
#       CompanyName, ObelixDatabaseName
#     ) %>%
#     tidyr::nest()
#
# }
#
# obxdbs <- obxdbs %>%
#   mutate(
#     con = map2(ObelixDatabaseName, data, obxGetDBConnection)
#   )
#
# obxdbs$data[[1]]



msg <- function(..., startup = FALSE) {
  # if (startup) {
  #   if (!isTRUE(getOption("tidyverse.quiet"))) {
  #     packageStartupMessage(text_col(...))
  #   }
  # } else {
    message(text_col(...))
  #}
}

text_col <- function(x) {
  # If RStudio not available, messages already printed in black
  if (!rstudioapi::isAvailable()) {
    return(x)
  }

  if (!rstudioapi::hasFun("getThemeInfo")) {
    return(x)
  }

  theme <- rstudioapi::getThemeInfo()

  if (isTRUE(theme$dark)) crayon::white(x) else crayon::black(x)

}
