
#' @return ih_table
#'
#' @export
obx_ih_get <- function(obxActiveContext, obxname, ihtype = "Unprocessed") {

  assertthat::assert_that(is.obxActiveContext(obxActiveContext))

  obxdbs <- obxActiveContext$obxdbs

  if(ihtype == "Unprocessed") {
    obxdbs <- obxdbs %>%
      mutate(
        unprocessed = map(con, obx_ih_unprocessed)
      )

    obxdbs <- obxdbs %>%
      select(
        CompanyName, ObelixDatabaseName, unprocessed
      ) %>%
      mutate(
        l = map_dbl(unprocessed, count_list)
      ) %>%
      filter(
        l > 0
      ) %>%
      select(
        -l
      )

    ret <- obxdbs %>% unnest()

  }

  if(ihtype == "All") {

    obxdbs <- obxdbs %>%
      mutate(
        ih_all = map(con, obx_ih_all)
      )

    ret <- obxdbs

  }

  return(ret)
}

obx_ih_unprocessed <- function(obxcon) {

  ih_unprocessed <- obx_ih_all(obxcon, which_col = c("ProcessedFlag"), which_val = c(0))

  ih_processed1 <- obx_ih_all(obxcon, which_col = c("ProcessedFlag"), which_val = c("1"))
  ih_processed2 <- obx_ih_all(obxcon, which_col = c("ProcessedFlag"), which_val = c("2"))
  ih_processed <- dplyr::bind_rows(ih_processed1, ih_processed2)

  # ih_unprocessed <- ih %>%
  #   filter(
  #     ProcessedFlag == 0
  #   )

  # ih_processed_max <- ih %>%
  #   filter(
  #     ProcessedFlag != 0
  #   ) %>%
  #   semi_join(
  #     ih_unprocessed, by = c("ClientCode", "SecurityCode")
  #   ) %>%
  #   group_by(
  #     ClientCode, SecurityCode
  #   ) %>%
  #   summarise(
  #     wavpoolorder = max(WavPoolOrder, na.rm = TRUE)
  #   )


  ih_processed_max <- ih_processed %>%
    semi_join(
      ih_unprocessed, by = c("ClientCode", "SecurityCode")
    ) %>%
    group_by(
      ClientCode, SecurityCode
    ) %>%
    summarise(
      wavpoolorder = max(WavPoolOrder, na.rm = TRUE)
    )

  ih_processed <- ih_processed %>%
    semi_join(
      ih_processed_max, by = c("ClientCode", "SecurityCode", "WavPoolOrder" = "wavpoolorder")
    ) %>%
    select(
      ClientCode
      , SecurityCode
      , CGTTransID
      , HPTransID
      , EffectiveDate
      , TradeType
      , TradeUnits
      , WavPoolOrder
      , UnitsRemainingWAV
      , BaseCostWAV
    ) %>%
    collect()

  ih_unprocessed <- ih_unprocessed %>%
    collect() %>%
    group_by(
      ClientCode, SecurityCode
    ) %>%
    nest()

  if(nrow(ih_unprocessed) > 0) {

    x <- nrow(ih_unprocessed)

    ih_unprocessed <- ih_unprocessed %>%
      mutate(
        data = map(data, rank_trans)
      )

    ih_unprocessed <- ih_unprocessed %>% unnest()
    ih_unprocessed <- ih_unprocessed %>%
      select(
        ClientCode
        , SecurityCode
        , unprocessed
        , InstrumentType
        , InstrumentSubType
        , CurrencyCode
        , DerivMultiplier
        , CGTTransID
        , HPTransID
        , EffectiveDate
        , TradeType
        , TradeUnits
      )

    ret <- ih_unprocessed %>%
      left_join(
        ih_processed, by = c("ClientCode", "SecurityCode")
      )

    ret <- ret %>%
      rename_at(.vars = vars(ends_with(".x")), .funs = funs(sub("[.]x$", "_u", .)))

    ret <- ret %>%
      rename_at(.vars = vars(ends_with(".y")), .funs = funs(sub("[.]y$", "", .)))

    ret <- ret %>% unnest()


  } else {
    ret <- NULL
  }

  return(ret)

}


obx_ih_all <- function(obxcon, which_col, which_val) {

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
      , CGTTransID
      , HPTransID
      , EffectiveDate
      , BrokerCode
      , TradeType
      , TradeUnits
      , Reversed
      , ProcessedFlag
      , WavPoolOrder
      , UnitsRemainingWAV
      , BaseCostWAV
      , TotalCostWAV
      , TradeType
      , TradeUnits
    ) %>%
    filter(
      Reversed == 0
    ) %>%
    filter(
      (!!rlang::sym(which_col))==which_val
    )

  return(ret)
}

rank_trans <- function(df) {

  df <- df %>%
    group_by(
      EffectiveDate, HPTransID
    ) %>%
    arrange(EffectiveDate, HPTransID)

  df <- tibble::rowid_to_column(df, "ID")

  m <- max(df$ID)

  ret <- df %>%
    filter(
      ID == 1
    ) %>%
    mutate(
      unprocessed = m
    )

  return(ret)

}


count_list <- function(df) {


  ret <- 0
  if(!is.null(df)) {
    #message("XXXX")
    df <- df %>% unlist()
    ret <- 1 #nrow(df) %>% unlist()
  }

  return(ret)

}
