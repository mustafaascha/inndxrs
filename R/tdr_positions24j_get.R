
#' @return transactions tbl
#'
#' @export
#'
tdr_positions24j_get <- function(con_tdr, universe) {

  tbl_positions24j <- dplyr::tbl(con_tdr, "PositionsS24J")


  universe <- universe %>%
    select(
      portfoliocode, instrumentcode, CompanyID, HiportDBID, SecurityType, SecuritySubType, SecurityClassName, ObelixDatabaseName, PositionID
    )

  tbl_positions24j <- tbl_positions24j %>%
    inner_join(
      universe, by = c("PositionID")
    )

  return(tbl_positions24j)

}
