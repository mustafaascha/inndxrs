#' @return ih_table
#'
#' @export
obelix_trans_unprocessed <- function(df) {
  df <- df %>%
    obelix_trans_filter(c("ProcessedFlag"), c(0))

  return(df)
}

#' @return ih_table
#'
#' @export
obelix_trans_filter <- function(df, which_col = c("ProcessedFlag"), which_val = c(0)) {

  df <- df %>%
    filter(
      (!!rlang::sym(which_col)) == which_val
    )

  return(df)
}



#' @return ih_table
#'
#' @export
obelix_trans_get <- function(obxcon) {

  obx_ih <- tbl(obxcon, "InstrumentHoldings")
  obx_cl <- tbl(obxcon, "ClientID")
  obx_in <- tbl(obxcon, "CGTInstrumentIDs")

  ret <- obx_ih %>%
    inner_join(
      obx_cl, by = c("CGTClientID")
    ) %>%
    inner_join(
      obx_in, by = c("CGTInstrumentID")
    ) %>%
    select(
      ClientCode
      , SecurityCode
      , InstrumentType
      , InstrumentSubType
      , CurrencyCode
      , DerivMultiplier

      , HPTransID
      , Reversed
      , ProcessedFlag
      , WavPoolOrder
      , EffectiveDate
      , TransactionType
      , TransactionSubType
      , BrokerCode
      , TradeType
      , TradeUnits
      , TransCost
      , TotalProceeds
      , NativePrice
      , ExchangeRate


      , UnitsRemainingWAV
      , BaseCostWAV
      , TotalCostWAV
      , TradeType
      , TradeUnits
      , CEProcessorID
      , EventID
      , OpenCloseFlag
      , CGTTransID
      , CGTClientID
      , CGTInstrumentID
    )

  ret <- ret %>%
    mutate(
      SecurityCode = substring(SecurityCode, 1, as.numeric(len(SecurityCode) - 5))
    ) %>%
    rename(
      portfoliocode = ClientCode,
      instrumentcode = SecurityCode
    )

  return(ret)
}
