#' @return An wd string
#' @export
wd <- function() {

  z <- here::here()

  return(z)
}

#' @return An wd string
#' @export
wd_data <- function(wd, dir = ""){

  if(dir == "") {
    dir <- "data-projects"
    dir2 <- "data-projects-raw"
  }
  z <- stringr::str_replace(wd, dir, dir2)

  return(z)
}
