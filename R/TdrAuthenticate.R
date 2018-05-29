#' Authenticates against TDR Database.
#'
#' @inheritParams setTdrContext
#' @param verbose If TRUE, prints verbose messages
#'
#' @return If successful, returns TRUE
#'
#' @export
tdrAuthenticate <- function(tdrActiveContext, svrname) {

  assertthat::assert_that(is.tdrActiveContext(tdrActiveContext))

  tdrAuthenticateDB(tdrActiveContext, svrname = svrname, verbose = verbose)

  #azureListSubscriptions(azureActiveContext) # this sets the subscription ID
  #if(verbose) message("Authentication succeeded: key obtained")
  return(TRUE)
}


#' Switch based on auth types.
#'
#' @inheritParams setTdrContext
#' @param verbose Print Tracing information (Default False)
#'
#' @return If successful, returns TRUE
#' @family TDR resource functions
#'
#' @export
tdrAuthenticateDB <- function(tdrActiveContext, svrname, verbose = FALSE) {
 assertthat::assert_that(is.tdrActiveContext(tdrActiveContext))

  if (missing(svrname)) svrname <- tdrActiveContext$servername

  print(paste0("Fetch TDR db connection using tdrServer = ", svrname))

  # result <- switch(
  #   tdrCon <- tdrGetDBConnection(tdrActiveContext),
  #   # authType,
  #   # RefreshToken = azureGetTokenRefreshToken(azureActiveContext),
  #   # ClientCredential = azureGetTokenClientCredential(azureActiveContext, resource = resource, verbose = verbose),
  #   # DeviceCode = azureGetTokenDeviceCode(azureActiveContext, resource = resource, verbose = verbose),
  #   FALSE
  # )

  result <- tdrGetDBConnection(tdrActiveContext)

  # persist valid auth type in the context
  if (result) {
    tdrActiveContext$servername <- svrname
    tdrActiveContext$connected <- result

    result <- tdrGetCompanies(tdrActiveContext)
  }

  return(result)
}


#' Get Azure token using RefreshToken
#'
#' @inheritParams setTdrContext
#'
#' @return If successful, returns TRUE
#'
#' @export
tdrGetDBConnection <- function(tdrActiveContext, verbose = FALSE) {
  assertthat::assert_that(is.tdrActiveContext(tdrActiveContext))

  con <- DBI::dbConnect(odbc::odbc(),
                        Driver = tdrActiveContext$driver,
                        Server = tdrActiveContext$serverurl,
                        Database = tdrActiveContext$database,
                        UID = tdrActiveContext$uid,
                        PWD = tdrActiveContext$pwd,
                        Port = tdrActiveContext$port)



  tdrActiveContext$connection <- con

  return(TRUE)
}

#' Get TDR Companies
#'
#' @inheritParams setTdrContext
#'
#' @return If successful, returns TRUE
#'
#' @export
tdrGetCompanies <- function(tdrActiveContext, verbose = FALSE){
  assertthat::assert_that(is.tdrActiveContext(tdrActiveContext))
  library(tidyverse)

  con_tdr <- tdrActiveContext$connection

  tdr_Universe <- dplyr::tbl(con_tdr, "vPortfolioSecurityUniverse")
  tdr_ObelixDatabaseServers <- dplyr::tbl(con_tdr, "ObelixDatabaseServers")
  tdr_ObelixDatabases <- dplyr::tbl(con_tdr, "ObelixDatabases")

  z <- tdr_Universe %>%
    dplyr::filter(
      !is.na(ObelixDatabaseName)
    ) %>%
    dplyr::inner_join(
      tdr_ObelixDatabases, by = c("ObelixDatabaseID")
    ) %>%
    dplyr::inner_join(
      tdr_ObelixDatabaseServers, by = c("ObelixDatabaseServerID")
    ) %>%
    dplyr::select(
      CompanyName,
      ObelixDatabaseName.x,
      ObelixDatabaseServerName,
      ObelixDatabaseConnectionString
    ) %>%
    dplyr::distinct() %>%
    rename(
      ObelixDatabaseName = ObelixDatabaseName.x
    )

  tdrActiveContext$companies <- z

  return(TRUE)

}

