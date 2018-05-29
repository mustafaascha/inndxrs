#' Authenticates against TDR Database.
#'
#' @inheritParams setObxContext
#' @param verbose If TRUE, prints verbose messages
#'
#' @return If successful, returns TRUE
#'
#' @export
obxAuthenticate <- function(obxActiveContext, obxname) {

  assertthat::assert_that(is.obxActiveContext(obxActiveContext))

  con <- obxAuthenticateDB(obxActiveContext, obxname = obxname, verbose = verbose)

  return(con)
}


#' Switch based on auth types.
#'
#' @inheritParams setObxContext
#' @param verbose Print Tracing information (Default False)
#'
#' @return If successful, returns TRUE
#' @family TDR resource functions
#'
#' @export
obxAuthenticateDB <- function(obxActiveContext, obxname, verbose = FALSE) {
  assertthat::assert_that(is.obxActiveContext(obxActiveContext))

  if (missing(obxname)) obxname <- obxActiveContext$obxname

  print(paste0("Fetch OBX db connection using obxDB = ", obxname))

  # result <- switch(
  #   tdrCon <- tdrGetDBConnection(tdrActiveContext),
  #   # authType,
  #   # RefreshToken = azureGetTokenRefreshToken(azureActiveContext),
  #   # ClientCredential = azureGetTokenClientCredential(azureActiveContext, resource = resource, verbose = verbose),
  #   # DeviceCode = azureGetTokenDeviceCode(azureActiveContext, resource = resource, verbose = verbose),
  #   FALSE
  # )

  result <- obxGetDBConnection(obxActiveContext, obxname)

  # persist valid auth type in the context
  # if (result) {
  #   obxActiveContext$obxname <- obxname
  #   obxActiveContext$connected <- result
  #
  #   #result <- tdrGetCompanies(tdrActiveContext)
  # }

  return(result)
}


#' Get Azure token using RefreshToken
#'
#' @inheritParams setTdrContext
#'
#' @return If successful, returns TRUE
#'
#' @export
obxGetDBConnection <- function(dbname, db, verbose = FALSE) {
  #assertthat::assert_that(is.obxActiveContext(obxActiveContext))

  con <- DBI::dbConnect(odbc::odbc(),
                        Driver = db$driver,
                        Server = db$serverurl,
                        Database = dbname,
                        UID = db$uid,
                        PWD = db$pwd,
                        Port = db$port)



  return(con)
}

#' #' Get TDR Companies
#' #'
#' #' @inheritParams setTdrContext
#' #'
#' #' @return If successful, returns TRUE
#' #'
#' #' @export
#' tdrGetCompanies <- function(tdrActiveContext, verbose = FALSE){
#'   assertthat::assert_that(is.tdrActiveContext(tdrActiveContext))
#'   library(tidyverse)
#'
#'   con_tdr <- tdrActiveContext$connection
#'
#'   tdr_Universe <- dplyr::tbl(con_tdr, "vPortfolioSecurityUniverse")
#'   tdr_ObelixDatabaseServers <- dplyr::tbl(con_tdr, "ObelixDatabaseServers")
#'   tdr_ObelixDatabases <- dplyr::tbl(con_tdr, "ObelixDatabases")
#'
#'   z <- tdr_Universe %>%
#'     dplyr::filter(
#'       !is.na(ObelixDatabaseName)
#'     ) %>%
#'     dplyr::inner_join(
#'       tdr_ObelixDatabases, by = c("ObelixDatabaseID")
#'     ) %>%
#'     dplyr::inner_join(
#'       tdr_ObelixDatabaseServers, by = c("ObelixDatabaseServerID")
#'     ) %>%
#'     dplyr::select(
#'       CompanyName,
#'       ObelixDatabaseName.x,
#'       ObelixDatabaseServerName,
#'       ObelixDatabaseConnectionString
#'     ) %>%
#'     dplyr::distinct() %>%
#'     rename(
#'       ObelixDatabaseName = ObelixDatabaseName.x
#'     )
#'
#'   tdrActiveContext$companies <- z
#'
#'   return(TRUE)
#'
#' }

