#' Create an OBX Context.
#'
#' Create a container (`azureObxContext`) for holding variables used by the `inndxrs` package.
#'
#' @inheritParams setObxContext
#' @inheritParams read.inndxrs.config
#' @family azureObxContext functions
#'
#' @return An `obxActiveContext` object
#' @export
createObxContext <- function(tdrActiveContext, cpyname){

  azEnv <- new.env(parent = emptyenv())
  azEnv <- as.obxActiveContext(azEnv)
  list2env(
    list(companyname = cpyname, obxdbs = NULL, serverurl = "", uid = "", pwd = "", driver = "", port = 0),
    envir = azEnv
  )
  if (!missing(tdrActiveContext)) {
    assertthat::assert_that(is.tdrActiveContext(tdrActiveContext))

    companies <- tdrActiveContext$companies %>% dplyr::collect()

    if(nrow(companies) > 0){
      obxdbs <- companies %>% dplyr::filter(CompanyName ==  cpyname)
    }

    azEnv$serverurl <- tdrActiveContext$serverurl
    azEnv$uid <- tdrActiveContext$uid
    azEnv$pwd <- tdrActiveContext$pwd
    azEnv$driver <- tdrActiveContext$driver
    azEnv$port <- tdrActiveContext$port

    if(nrow(obxdbs) >= 1){

      obxdbs <- obxdbs %>%
        dplyr::mutate(
          serverurl = tdrActiveContext$serverurl,
          uid = tdrActiveContext$uid,
          pwd = tdrActiveContext$pwd,
          driver = tdrActiveContext$driver,
          port = tdrActiveContext$port
        ) %>%
        dplyr::group_by(
          CompanyName, ObelixDatabaseName
        ) %>%
        tidyr::nest()

      obxdbs <- obxdbs %>%
        dplyr::mutate(
          con = purrr::map2(ObelixDatabaseName, data, obxGetDBConnection)
        )

      azEnv$obxdbs <- obxdbs

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
#' Updates the value of an `obxActiveContext` object, created by [createObxContext()]
#'
#' @param obxActiveContext A container used for caching variables used by `inndxrs`, created by [createObxContext()]
#' @param companyname The port
#'
#' @family obxActiveContext functions
#' @export
setObxContext <- function(obxActiveContext, companyname)
{
  #if (!missing(companyname)) obxActiveContext$companyname <- companyname

  if (!missing(companyname)) {
    assert_that(is_companyname(companyname))
    obxActiveContext$companyname <- companyname
  }
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

