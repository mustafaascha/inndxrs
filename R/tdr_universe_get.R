#' @return universe tbl
#'
#' @export
#'
tdr_universe_get <- function(con_tdr, company_name = "",
                             portfolio_group_name = "",
                             portfolio_code = "",
                             security_class_name = "",
                             portfolio_allocated = TRUE,
                             obx_database = "",
                             security_code = "") {


  tbl_universe <- dplyr::tbl(con_tdr, "vPortfolioSecurityUniverse")

  company_unique_groups <- tdr_company_unique_groups(con_tdr, company_name = company_name)


  if (company_name != "") {
    tbl_universe <- tbl_universe %>%
      dplyr::filter(
        CompanyName == company_name
      )
  }

  if(portfolio_group_name != "") {
    tbl_portfolio_groups <- dplyr::tbl(con_tdr, "PortfolioGroups")
    tbl_portfolio_groups_portfolios <- dplyr::tbl(con_tdr, "PortfolioGroupPortfolios")

    tbl_portfolio_ids <- tbl_portfolio_groups %>%
      dplyr::filter(
        PortfolioGroupName == portfolio_group_name
      ) %>%
      dplyr::inner_join(
        tbl_portfolio_groups_portfolios, by = c("PortfolioGroupID")
      ) %>%
      dplyr::select(
        PortfolioID
      )

    tbl_universe <- tbl_universe %>%
      dplyr::semi_join(
        tbl_portfolio_ids, by = c("PortfolioID")
      )
  }

  if(portfolio_code != "") {
    tbl_universe <- tbl_universe %>%
      dplyr::filter(
        PortfolioCode == portfolio_code
      )
  }

  if(security_class_name != "") {
    tbl_universe <- tbl_universe %>%
      dplyr::filter(
        SecurityClassName == security_class_name
      )
  }

  if(portfolio_allocated){
    tbl_universe <- tbl_universe %>%
      dplyr::filter(
        !is.na(ObelixDatabaseName)
      )
  }

  if(obx_database != ""){
    tbl_universe <- tbl_universe %>%
      dplyr::filter(
        ObelixDatabaseName == obx_database
      )
  }

  if(security_code != ""){
    tbl_universe <- tbl_universe %>%
      dplyr::filter(
        SecurityCode == security_code
      )
  }

  universe <- tbl_universe %>%
    dplyr::left_join(
      company_unique_groups, by = c("CompanyID", "PortfolioID")
    ) %>%
    dplyr::rename(
      portfoliocode = PortfolioCode,
      instrumentcode = SecurityCode
    )

  return(universe)
}

tdr_company_unique_groups <- function(con_tdr, company_name = "") {

  tbl_PortfolioGroupsAddValues <- dplyr::tbl(con_tdr, "PortfolioGroupsAddValues")
  tbl_PortfolioGroupsAdditional <- dplyr::tbl(con_tdr, "PortfolioGroupsAdditional")
  tbl_PortfolioGroups <- dplyr::tbl(con_tdr, "PortfolioGroups")
  tbl_Companies <- dplyr::tbl(con_tdr, "Companies")
  tbl_PortfolioGroupPortfolios <- dplyr::tbl(con_tdr, "PortfolioGroupPortfolios")


  company_unique_groups <- tbl_PortfolioGroupsAdditional %>%
    dplyr::filter(
      FieldName == "CompanyUnique"
    ) %>%
    dplyr::inner_join(
      tbl_PortfolioGroupsAddValues, by = c("PG_ADD_ID")
    ) %>%
    dplyr::filter(
      NumericValue == 1
    ) %>%
    dplyr::inner_join(
      tbl_PortfolioGroups,  by = "PortfolioGroupID"
    ) %>%
    dplyr::inner_join(
      tbl_Companies, by = "CompanyID"
    )

  if (company_name != "") {
    company_unique_groups <- company_unique_groups %>%
      dplyr::filter(
        CompanyName == company_name
      )
  }

  company_unique_groups <- company_unique_groups %>%
    dplyr::inner_join(
      tbl_PortfolioGroupPortfolios, by = c("PortfolioGroupID")
    ) %>%
    dplyr::select(
      CompanyID, PortfolioGroupID, PortfolioGroupName, PortfolioID
    )

  return(company_unique_groups)

}
