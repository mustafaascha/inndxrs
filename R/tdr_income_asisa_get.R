
#' @return transactions tbl
#'
#' @export
#'
tdr_income_asisa_get <- function(con_tdr, universe) {

  tbl_income <- dplyr::tbl(con_tdr, "arc_asisa_Income_Converted")

  tbl_income <- tbl_income %>%
    filter(
      CurrencyTo == ReportCurrency,
      Duplicated == 0
    )

  # tbl_income <- tbl_income %>%
  #   rename(
  #     portfoliocode = PortfolioIDCode,
  #     instrumentcode = InstrumentCode
  #   )

  tbl_income <- tbl_income %>%
    select(
      -PortfolioIDCode,
      -InstrumentCode,
      -PortfolioName,
      -AssetManagerCode,
      -AssetManagerName,
      -ReportEndDate,
      -ReportRunDate,
      -ReportRunTime,
      -ReportStartDate,
      -ClosingBalance_MAX,
      -ClosingBalance_MIN,
      -DividendIncomeEarned_MAX,
      -DividendIncomeEarned_MIN,
      -WithholdingTax_MAX,
      -WithholdingTax_MIN,
      -PrevClosingBalance_MAX,
      -PrevClosingBalance_MIN,
      -OpeningBalance_MAX,
      -OpeningBalance_MIN,
      -InterestIncomeEarned_MAX,
      -InterestIncomeEarned_MIN,
      -InterestIncomePaid_MAX,
      -InterestIncomePaid_MIN,
      -DividendIncomePaid_MAX,
      -DividendIncomePaid_MIN,
      -Id
    )

  tbl_income <- tbl_income %>%
    mutate(
      effectivedate_int = sql("dbo.fn_DateTime2Obelix(EffectiveDate)")
    )

  tbl_income <- tbl_income %>%
    mutate(
      date_int = effectivedate_int
    )



  universe <- universe %>%
    select(
      portfoliocode, instrumentcode, CompanyID, HiportDBID, SecurityType, SecuritySubType, SecurityClassName, ObelixDatabaseName, PortfolioID, SecurityID
    )

  tbl_income <- tbl_income %>%
    inner_join(
      universe, by = c("PortfolioID", "SecurityID", "CompanyID", "HiportDBID")
    )





  # col_names <- names(tbl_income)
  #
  # key_names <- c("portfoliocode",
  #                "instrumentcode",
  #                "SecurityClassName",
  #                "SecurityType",
  #                "SecuritySubType",
  #                "ObelixDatabaseName",
  #                "CompanyID",
  #                "HiportDBID", "date_int")
  #
  #
  # other_names <- col_names[!col_names %in% key_names]
  #
  # tbl_income <- tbl_income %>%
  #   select(
  #     key_names, other_names
  #   )

  tbl_income <- reorder_cols(tbl_income)

  tbl_income <- tbl_income %>%
    rename(
      cb = ClosingBalance,
      pcb = PrevClosingBalance,
      ob = OpeningBalance,
      ie = InterestIncomeEarned,
      ip = InterestIncomePaid,
      r = Rate
    )


  tbl_income <- tbl_income %>%
    mutate(
      cb = cb*r
      , pcb = pcb*r
      , ob = ob*r
      , WithholdingTax = 	WithholdingTax*r
      , DividendIncomeEarned = DividendIncomeEarned*r
      , DividendIncomePaid = DividendIncomePaid*r
      , ie = ie*r
      , ip = ip*r
    )


  return(tbl_income)

}
