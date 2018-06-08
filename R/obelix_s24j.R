#' @return s24j_table
#'
#' @export


obelix_s24j_get <- function(obxcon) {

  #obx_aia <- tbl(obxcon, "AIA_AUDIT")
  obx_aia_wav <- tbl(obxcon, "AIA_AUDIT_WAV")
  obx_cl <- tbl(obxcon, "ClientID")
  obx_in <- tbl(obxcon, "CGTInstrumentIDs")

  ret <- obx_aia_wav %>%
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

      , AccrualDate,
      CalcNo,
      AiaRecType,
      AiaAdjustAmt,
      YTM,
      ClosingUnits,
      ClosingAIA,
      CalcAIA,
      BooksCloseUnits,
      BooksCloseAIA,
      UnitSS4A,
      IndexRatio,
      IndexRatioBC,
      IsRepo



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
