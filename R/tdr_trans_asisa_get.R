
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
  return(tbl_transactions)

}
