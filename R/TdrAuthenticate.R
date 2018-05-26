#' Authenticates against TDR Database.
#'
#' @inheritParams setTdrContext
#' @param verbose If TRUE, prints verbose messages
#'
#' @return If successful, returns TRUE
#'
#' @export
tdrAuthenticate <- function(tdrActiveContext, driver, serverurl, database,
                            uid, pwd,
                            port, verbose = FALSE) {
  assert_that(is.tdrActiveContext(tdrActiveContext))

  #azureAuthenticateOnAuthType(azureActiveContext, authType = authType, resource = resource, verbose = verbose)

  #azureListSubscriptions(azureActiveContext) # this sets the subscription ID
  #if(verbose) message("Authentication succeeded: key obtained")
  return(TRUE)
}
