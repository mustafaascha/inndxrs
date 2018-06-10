
#' @return transactions tbl
#'
#' @export
#'
tdr_trans_asisa_get <- function(con_tdr, universe) {

  tbl_transactions <- dplyr::tbl(con_tdr, "arc_asisa_Transactions_Converted")
  tbl_trans_mappings <- dplyr::tbl(con_tdr, "asisa_TransactionTypeMappings")
  tbl_TransactionTypes <- dplyr::tbl(con_tdr, "TransactionTypes")

  tbl_trans_mappings <- tbl_trans_mappings %>%
    mutate(
      OpenCloseIndicator = if_else(is.na(OpenCloseIndicator), "", OpenCloseIndicator),
      SecuritySubType = as.integer(SecuritySubType)
    ) %>%
    semi_join(
      tdr_universe, by = c("CompanyId" = "CompanyID", "HiportDbId" = "HiportDBID")
    )

  tbl_trans_mappings <- tbl_trans_mappings %>%
    select(
      -Id, -HiportDbId, -CompanyId
    ) %>%
    left_join(
      tbl_TransactionTypes, by = c("TargetType" = "TransactionType")
    )

  tbl_transactions <- tbl_transactions %>%
    rename(
      portfoliocode = PortfolioIDCode,
      instrumentcode = InstrumentCode
    )


  universe <- universe %>%
    select(
      portfoliocode, instrumentcode, CompanyID, HiportDBID, SecurityType, SecuritySubType, SecurityClassName, ObelixDatabaseName
    )

  tbl_transactions <- tbl_transactions %>%
    inner_join(
      universe, by = c("portfoliocode", "instrumentcode", "CompanyID", "HiportDBID")
    ) %>%
    mutate(
      OpenCloseIndicator = if_else(is.na(OpenCloseIndicator), "", OpenCloseIndicator)
    )

  tbl_transactions <- tbl_transactions %>%
    left_join(
      tbl_trans_mappings, by = c("TransactionCode" = "SourceType", "TransactionSubType" = "SourceSubType", "SecurityType" = "SecurityType", "SecuritySubType" = "SecuritySubType", "OpenCloseIndicator" = "OpenCloseIndicator")
    )

  tbl_transactions <- tbl_transactions %>%
    mutate(
      effectivedate_int = sql("dbo.fn_DateTime2Obelix(EffectiveDate)"),
      entrydate_int = sql("dbo.fn_DateTime2Obelix(EntryDate)"),
      tradedate_int = sql("dbo.fn_DateTime2Obelix(TradeDate)"),
      settlementdate_int = sql("dbo.fn_DateTime2Obelix(SettlementDate)")
    )

  tbl_transactions <- tbl_transactions %>%
    mutate(
      date_int = settlementdate_int
    )

  tbl_transactions <- reorder_cols(tbl_transactions)

  tbl_transactions <- tbl_transactions %>%
    mutate(
      date_int = if_else(SecurityClassName == "Bonds", settlementdate_int, effectivedate_int)
      , Deleted = sql("ISNULL(Deleted, 0)")     #if_else(!is.na(Deleted), 0, Deleted)
      , Quantity = if_else(FlipUnitSign, -1*Quantity, Quantity)
      #
      , AssetAllInConsideration = if_else(FlipCostSign, -1* AssetAllInConsideration,  AssetAllInConsideration)
      , BaseAllInConsideration = if_else(FlipCostSign, -1* BaseAllInConsideration,  BaseAllInConsideration)
      #
      , asset_cost = if_else(IsPurchase == 1, AssetAllInConsideration, 0)
      , asset_proceeds = if_else(IsSale == 1, AssetAllInConsideration, 0)
      #
      , base_cost = if_else(IsPurchase == 1, BaseAllInConsideration, 0)
      , base_proceeds = if_else(IsSale == 1, BaseAllInConsideration, 0)
      #
      , asset_icome_p = if_else(IsPurchase == 1,  AssetIncome, 0)
      , asset_icome_s = if_else(IsSale == 1,  AssetIncome, 0)
      #
      , base_icome_p = if_else(IsPurchase == 1,  BaseIncome, 0)
      , base_icome_s = if_else(IsSale == 1,  BaseIncome, 0)
    )


  return(tbl_transactions)

}
