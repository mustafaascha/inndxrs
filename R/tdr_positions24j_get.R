
#' @return transactions tbl
#'
#' @export
#'
tdr_positions24j_get <- function(con_tdr, universe) {

  tbl_positions24j <- dplyr::tbl(con_tdr, "PositionsS24J")

  tbl_positions24j <- tbl_positions24j %>%
    mutate(
      date_int = EndDate
    )

  tbl_positions24j <- tbl_positions24j %>%
    rename(
    oai  = OpeningAccruedInterest,
    ib = IncomeBought,
    is = IncomeSold,
    pa = ProceedsAdjustment,
    ei = EntitlementIncome,
    cai = ClosingAccruedInterest,
    ie = IncomeEarned,
    cp = CouponIncludingAdjustments
    )


  universe <- universe %>%
    select(
      portfoliocode, instrumentcode, CompanyID, HiportDBID, SecurityType, SecuritySubType, SecurityClassName, ObelixDatabaseName, PositionID
    )

  tbl_positions24j <- tbl_positions24j %>%
    inner_join(
      universe, by = c("PositionID")
    )



  tbl_positions24j <- reorder_cols(tbl_positions24j)

  return(tbl_positions24j)

}


#' @return transactions tbl
#'
#' @export
#'
tdr_s24j_reasonability_get <- function(con_tdr, universe) {

  tbl_s24j <- dplyr::tbl(con_tdr, "ObelixS24JReasonability_Report")
  tbl_rr <- tbl(con_tdr, "ObelixDailyReportRuns")




  tbl_s24j <- tbl_s24j %>%
    rename(
      obc = ObelixCoupon,
      obccp = CouponCapitalPortion,
      hpc = HiportCoupon,
      cd = CouponDiffPrev,
      obs24j = ObelixS24J,
      obss4a = ObelixSS4A,
      obint = ObelixInterest,
      hpint = HiportInterest,
      s24jadjpre = S24JAdjustPrev,
      pbss4apre = ObelixSS4APrev,
      s24jmovepre = S24JAdjustMovePrev,
      obss4amove = ObelixSS4AMove,
      obs24i = ObelixS24I,
      sunits = TotalSaleUnitsToDate,
      obunits = ObelixUnrealisedUnits
    )

  universe <- tdr_universe %>%
    select(
      portfoliocode, instrumentcode, CompanyID, HiportDBID, SecurityType, SecuritySubType, SecurityClassName, ObelixDatabaseName, PortfolioID, SecurityID
    )

  tbl_rr <- tbl_rr %>%
    select(
      -PortfolioID
    )

  tbl_s24j <- universe %>%
    inner_join(
      tbl_s24j, by = c("PortfolioID", "SecurityID")
    ) %>%
    inner_join(
      tbl_rr, by = c("ObelixDailyReportRunID", "PortfolioGroupID")
    )

  tbl_s24j <- tbl_s24j %>%
    mutate(
      date_int = ObelixDailyReportRunDateTo
    )

  tbl_s24j <- tbl_s24j %>%
    select(
      -PortfolioGroupID,
      -PortfolioID,
      -UserID,
      -SecurityID,
      -ObelixDailyReportID,
      -ObelixDailyReportRunCreated,
      -ObelixDailyReportRunDateFrom,
      -ObelixDailyReportRunDateTo,
      -ObelixDailyReportRunID,
      -ObelixDailyReportRunRecalc,
      -CouponAutoComment,
      -CouponComment,
      -S24JAutoComment,
      -S24JComment,
      -S24JMoveAutoComment,
      -S24JMoveComment,
      -S24JMoveReason,
      -S24JReason,
      -S24JReportID,
      -CouponTimingDate,
      -CouponReason

    )


  tbl_s24j <- reorder_cols(tbl_s24j)


  return(tbl_s24j)

}


