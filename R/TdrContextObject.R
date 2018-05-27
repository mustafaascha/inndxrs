#' Create an TDR Context.
#'
#' Create a container (`azureTdrContext`) for holding variables used by the `inndxrs` package.
#'
#' @inheritParams setTdrContext
#' @inheritParams read.inndxrs.config
#' @family azureTdrContext functions
#'
#' @return An `tdrActiveContext` object
#' @export
createTdrContext <- function(configFile, svrname){
  azEnv <- new.env(parent = emptyenv())
  azEnv <- as.tdrActiveContext(azEnv)
  list2env(
    list(servername = svrname, connected = FALSE, driver = "", serverurl = "", database = "", uid = "", pwd = "", port = 0, connection = NULL),
    envir = azEnv
  )
  if (!missing(configFile)) {
    config <- read.inndxrs.config(configFile)
    list2env(config, envir = azEnv)
    #tdrAuthenticate(azEnv)
  }

  if(nrow(config$tdrservers) > 0){
    servers <- tibble::as_tibble(config$tdrservers)
    server <-  dplyr::filter(servers, servername ==  svrname)
  }

  if(nrow(server) == 1){
    azEnv$driver <- server$driver
    azEnv$serverurl <- server$serverurl
    azEnv$database <- server$database
    azEnv$uid <- server$uid
    azEnv$pwd <- server$pwd
    azEnv$port <- server$port

    tdrauth <- tdrAuthenticate(azEnv)

    if(tdrauth) {

      tdrGetCompanies(azEnv)
    }
  }



  # else {
  #   if (!missing(driver)) azEnv$driver <- driver
  #   if (!missing(serverurl)) azEnv$serverurl <- serverurl
  #   if (!missing(database)) azEnv$database <- database
  #   if (!missing(uid)) azEnv$uid <- uid
  #   if (!missing(pwd)) azEnv$pwd <- pwd
  #   if (!missing(port)) azEnv$port <- port
  #   if (!missing(server) && !missing(database)) {
  #     tdrAuthenticate(azEnv)
  #   }
  # }



  return(azEnv)
}



#' Updates tdrActiveContext object.
#'
#' Updates the value of an `tdrActiveContext` object, created by [createTdrContext()]
#'
#' @param tdrActiveContext A container used for caching variables used by `inndxrs`, created by [createTdrContext()]
#' @param driver The driver
#' @param serverurl The serverurl
#' @param database The TDR database
#' @param uid Resource uid
#' @param pwd The pwd
#' @param port The port
#'
#' @family tdrActiveContext functions
#' @export
setTdrContext <- function(tdrActiveContext, driver, serverurl, database,
                          uid, pwd,
                          port)
{
  if (!missing(driver)) tdrActiveContext$driver <- driver
  if (!missing(serverurl)) tdrActiveContext$serverurl <- serverurl
  if (!missing(database)) tdrActiveContext$database <- database
  if (!missing(uid)) tdrActiveContext$uid <- uid
  if (!missing(pwd)) tdrActiveContext$pwd <- pwd
  if (!missing(port)) tdrActiveContext$port <- port

  # if (!missing(subscriptionID)) {
  #   assert_that(is_subscription_id(subscriptionID))
  #   azureActiveContext$subscriptionID <- subscriptionID
  # }
  # if (!missing(resourceGroup)) {
  #   assert_that(is_resource_group(resourceGroup))
  #   azureActiveContext$resourceGroup <- resourceGroup
  # }
  # if (!missing(storageKey)) {
  #   assert_that(is_storage_key(storageKey))
  #   azureActiveContext$storageKey <- storageKey
  # }
  # if (!missing(storageAccount)) {
  #   assert_that(is_storage_account(storageAccount))
  #   azureActiveContext$storageAccount <- storageAccount
  # }
  # if (!missing(container)) {
  #   assert_that(is_container(container))
  #   azureActiveContext$container <- container
  # }
  # if (!missing(blob)) {
  #   assert_that(is_blob(blob))
  #   azureActiveContext$container <- blob
  # }
  #
  # if (!missing(vmName)) {
  #   assert_that(is_vm_name(vmName))
  #   azureActiveContext$vmName <- vmName
  # }
  #
  # if (!missing(clustername)) azureActiveContext$clustername <- clustername
  # if (!missing(hdiAdmin)) azureActiveContext$hdiAdmin <- hdiAdmin
  # if (!missing(hdiPassword)) azureActiveContext$hdiPassword  <- hdiPassword
  # if (!missing(kind)) azureActiveContext$kind <- kind
  # if (!missing(sessionID)) azureActiveContext$sessionID <- sessionID
  #
  # if (!missing(authType)) azureActiveContext$authType <- authType
  # if (!missing(resource)) azureActiveContext$resource <- resource
}

