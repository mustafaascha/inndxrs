
#' @return holdings tbl
#'
#' @export
#'
tdr_holdings_asisa_get <- function(con_tdr, universe, holdings_date) {

  tbl_holdings <- dplyr::tbl(con_tdr, "arc_asisa_Holdings_Converted")

  universe <- universe %>%
    select(
      portfoliocode, instrumentcode, CompanyID, HiportDBID, SecurityType, SecuritySubType, SecurityClassName, ObelixDatabaseName
    )

  tbl_holdings <- tbl_holdings %>%
    rename(
      portfoliocode = PortfolioIDCode,
      instrumentcode = InstrumentCode
    )

  tbl_holdings <- tbl_holdings %>%
    inner_join(
      universe, by = c("portfoliocode", "instrumentcode", "CompanyID" = "CompanyID", "HiportDBID" = "HiportDBID")
    )

  if(!missing(holdings_date)){

    tbl_holdings <- tbl_holdings %>%
      filter(
        ValuationDate == holdings_date
      )
  }

  return(tbl_holdings)

}
