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



ac <- inndxrs::createTdrContext(configFile = getOption("inndxrs.config"), svrname = "Azure")

obx <- inndxrs::createObxContext(tdrActiveContext = ac, cpyname = "Coronation")

xxx <- obx_ih_get(obxActiveContext = obx, obxname = "", ihtype = "Unprocessed")


ac <- inndxrs::createTdrContext(configFile = getOption("inndxrs.config"), svrname = "Azure")

con_tdr <- ac$connection

universe <- inndxrs::tdr_universe_get(con_tdr = con_tdr, company_name = "Coronation", portfolio_allocated = FALSE, portfolio_group_name = "")


# #
# # xxx <- obx_ih_get(obxActiveContext = obx, obxname = "", ihtype = "All")
# #
# # xxx$ih_all
#
# obxcon <- obx$obxdbs$con[[1]]
#
# ih_unprocessed <- obx_ih_all(obxcon, which_col = c("ProcessedFlag"), which_val = c(0))
#
# ih_unprocessed %>%
#   filter_at(
#     vars(c("ClientCode", "SecurityCode")), all_vars(. == c("20754", "R2023_1ZAR"))
#   )
#
#
# ih_unprocessed %>%
#   filter_at(
#     vars(c("InstrumentSubType")), all_vars(. != "10")
#   )
#
#
#
# tidyselect::vars_select(ih_unprocessed, starts_with("S"))
#
# ih_processed1 <- obx_ih_all(obxcon, which_col = c("ProcessedFlag"), which_val = c(1))
# ih_processed2 <- obx_ih_all(obxcon, which_col = c("ProcessedFlag"), which_val = c(2))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# xxx <- obx_ih_all(con, which_col = c("SecurityCode"), which_val = c("ABCPI3_1ZAR"))
#
#
# simpleFunction <- function(dataset, col_name, value){
#   require("dplyr")
#   require("lazyeval")
#   filter_criteria <- interp(~y == x, .values=list(y = as.name(col_name), x = value))
#   dataset %>%
#     filter_(filter_criteria) %>%
#     summarise(mean_speed = mean(speed)) -> dataset
#   return(dataset)
# }
#
#
# simpleFunction(cars, "dist", 10)
#
#
# obxdbs <- obx$obxdbs
#
# obxdbs <- obxdbs %>%
#   mutate(
#     unprocessed = map(con, obx_ih_unprocessed)
#   )
#
#
#
# xxx <- obxdbs %>%
#   select(
#     CompanyName, ObelixDatabaseName, unprocessed
#   ) %>%
#   mutate(
#     l = map_dbl(unprocessed, count_list)
#   ) %>%
#   filter(
#     l > 0
#   ) %>%
#   select(
#     -l
#   )
#
#
#
#
#
#
#
#
#
#
# packages <- paste0(
#   crayon::green(cli::symbol$tick), " ", crayon::blue(format(to_load)), " ",
#   crayon::col_align(versions, max(crayon::col_nchar(versions)))
# )
#
# st <- paste0(crayon::green(cli::symbol$warning), " ", " Test")
#
# msg(st)
#
# #
# ac <- inndxrs:::createTdrContext(configFile = getOption("inndxrs.config"), svrname = "Azure")
# servers <- tibble::as_tibble(ac$tdrservers)
#
# ac$companies$ObelixDatabaseServerName
# #
# #
# # cpyname <- "Liberty"
# # obxdbs <- ac$companies %>% dplyr::filter(CompanyName ==  cpyname)
# #
# #
# # inndxrs:::createObxContext(tdrActiveContext = ac, cpyname = cpyname)
# #
# #
# # companies <- ac$companies %>% dplyr::collect()
# #
# # if(nrow(companies) > 0){
# #   obxdbs <- companies %>% dplyr::filter(CompanyName ==  cpyname)
# # }
# #
# #
# # if(nrow(obxdbs) >= 1){
# #
# #   obxdbs <- obxdbs %>%
# #     dplyr::mutate(
# #       serverurl = ac$serverurl,
# #       uid = ac$uid,
# #       pwd = ac$pwd,
# #       driver = ac$driver,
# #       port = ac$port
# #     ) %>%
# #     dplyr::group_by(
# #       CompanyName, ObelixDatabaseName
# #     ) %>%
# #     tidyr::nest()
# #
# # }
# #
# # obxdbs <- obxdbs %>%
# #   mutate(
# #     con = map2(ObelixDatabaseName, data, obxGetDBConnection)
# #   )
# #
# # obxdbs$data[[1]]
#
#
#
# msg <- function(..., startup = FALSE) {
#   # if (startup) {
#   #   if (!isTRUE(getOption("tidyverse.quiet"))) {
#   #     packageStartupMessage(text_col(...))
#   #   }
#   # } else {
#     message(text_col(...))
#   #}
# }
#
# text_col <- function(x) {
#   # If RStudio not available, messages already printed in black
#   if (!rstudioapi::isAvailable()) {
#     return(x)
#   }
#
#   if (!rstudioapi::hasFun("getThemeInfo")) {
#     return(x)
#   }
#
#   theme <- rstudioapi::getThemeInfo()
#
#   if (isTRUE(theme$dark)) crayon::white(x) else crayon::black(x)
#
# }
