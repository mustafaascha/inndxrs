#' @return securities tbl
#'
#' @export
tdr_securities_get <- function(con_tdr, tablename = "Securities", universe = TRUE, assigned = TRUE, companyname = "", assetclass = "", unijoin = "") {

  if(!missing(tablename)) {
    arc_table <- dplyr::tbl(con_tdr, tablename)
  }

  if(universe & unijoin != "") {
    tdr_Universe <- dplyr::tbl(con_tdr, "vPortfolioSecurityUniverse")

    if(companyname != "") {
      tdr_Universe <- tdr_Universe %>%
        dplyr::filter(
          CompanyName == companyname
        )
    }

    if(assigned) {
      tdr_Universe <- tdr_Universe %>%
        dplyr::filter(
          !is.na(ObelixDatabaseName)
        )
    }

    if(assetclass != "") {
      tdr_Universe <- tdr_Universe %>%
        dplyr::filter(
          SecurityClassName == assetclass
        )
    }

    arc_table <- arc_table %>%
      dplyr::semi_join(
        tdr_Universe, by = unijoin
      )

  }

  return(arc_table)


}
