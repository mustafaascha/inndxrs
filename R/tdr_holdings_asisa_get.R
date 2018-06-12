
#' @return holdings tbl
#'
#' @export
#'
tdr_holdings_asisa_get <- function(con_tdr, universe, holdings_date) {

  tbl_holdings <- dplyr::tbl(con_tdr, "arc_asisa_Holdings_Converted")

  tbl_holdings <- tbl_holdings %>%
    mutate(
      date_int = sql("dbo.fn_DateTime2Obelix(ValuationDate)")
    )

  if(!missing(holdings_date)){

    tbl_holdings <- tbl_holdings %>%
      filter(
        date_int == holdings_date
      )
  }

  tbl_holdings <- tbl_holdings %>%
    rename(
      nom = HoldingNominal,

      aai = AssetAccruedIncome,
      abv = AssetBookValue,
      aee = AssetEffectiveExposure,
      amv = AssetMarketValue,
      amvc = AssetMarketValueClean,
      aupl = AssetUnrealisedProfitLoss,
      aubs = AssetUnsettledBoughtSoldIncome,

      bai = BaseAccruedIncome,
      bbv = BaseBookValue,
      bee = BaseEffectiveExposure,
      bmv = BaseMarketValue,
      bmvc = BaseMarketValueClean,
      bupl = BaseUnrealisedProfitLoss,
      bubs = BaseUnsettledBoughtSoldIncome

    )

  cols_remove <- c("ValuationDate",
                   "ValuationTime",
                   "ReportRunDate",
                   "ReportRunTime",
                   "PortfolioAssetCurrency",
                   "PortfolioReportingCurrency",
                   "TotalBookValue",
                   "TotalMarketValue",
                   "AppreciationDepreciationFuture",
                   "AssetAccruedExpenses",
                   "AssetAverageCost",
                   "AssetMarketPrice",
                   "AssetMarketPriceClean",
                   "AssetMarketPriceAllIn",
                   "BaseAccruedExpenses",
                   "BaseAverageCost",
                   "BaseMarketPriceCum",
                   "BaseMarketPriceClean",
                   "BaseMarketPriceAllIn",
                   "BaseMarketYield",
                   "PortfolioIDCode",
                   "InstrumentCode")


  tbl_holdings <- tbl_holdings %>%
    select(
      -cols_remove
    )

  universe <- universe %>%
    select(
      portfoliocode, instrumentcode, CompanyID, HiportDBID, SecurityType, SecuritySubType, SecurityClassName, ObelixDatabaseName, PortfolioID, SecurityID
    )

  # tbl_holdings <- tbl_holdings %>%
  #   rename(
  #     portfoliocode = PortfolioIDCode,
  #     instrumentcode = InstrumentCode
  #   )

  tbl_holdings <- tbl_holdings %>%
    inner_join(
      universe, by = c("PortfolioID", "SecurityID", "CompanyID" = "CompanyID", "HiportDBID" = "HiportDBID")
    )


  tbl_holdings <- reorder_cols(tbl_holdings)

  return(tbl_holdings)

}
