
#' @return transactions tbl
#'
#' @export
#'
tdr_income_asisa_get <- function(con_tdr, universe) {

  tbl_income <- dplyr::tbl(con_tdr, "arc_asisa_Income_Converted")

  tbl_income <- tbl_income %>%
    rename(
      portfoliocode = PortfolioIDCode,
      instrumentcode = InstrumentCode
    )

  universe <- universe %>%
    select(
      portfoliocode, instrumentcode, CompanyID, HiportDBID, SecurityType, SecuritySubType, SecurityClassName, ObelixDatabaseName
    )

  tbl_income <- tbl_income %>%
    inner_join(
      universe, by = c("portfoliocode", "instrumentcode", "CompanyID", "HiportDBID")
    )

  return(tbl_income)

}
