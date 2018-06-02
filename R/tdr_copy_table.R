tdr_copy_table <- function(tablename, con_tdr, numfields) {

  if(!missing(tablename)){

    fields <- DBI::dbListFields(con_tdr, tablename) %>% tibble::as_tibble()

    fields <- fields %>%
      dplyr::rename(
        fieldname = value
      ) %>%
      dplyr::mutate(
        fieldtype = "VARCHAR(255)"
      )


    fields[fields$fieldname %in% numfields, ]$fieldtype <- "FLOAT"

    fields_s <- paste0(fields$fieldname, " ", fields$fieldtype, ",")

    fields_f <- paste(fields_s, sep = '', collapse = '')

    s1 <- paste0("CREATE TABLE [dbo].[tmp_", tablename, "] (")

    sql_create <- paste(s1, substr(fields_f,1,nchar(fields_f)-1), ")")


    sql_drop <- paste0("DROP TABLE IF EXISTS [dbo].[tmp_", tablename, "]")
    sql_insert <- paste0("INSERT INTO [dbo].[tmp_", tablename, "] SELECT * FROM [dbo].[", tablename, "]")

    rs <- DBI::dbSendStatement(conn = con_tdr, statement = sql_drop)

    DBI::dbHasCompleted(rs)
    DBI::dbGetRowsAffected(rs)
    DBI::dbClearResult(rs)

    rs <- DBI::dbSendStatement(conn = con_tdr, statement = sql_create)
    DBI::dbHasCompleted(rs)
    DBI::dbGetRowsAffected(rs)
    DBI::dbClearResult(rs)

    rs <- DBI::dbSendStatement(conn = con_tdr, statement = sql_insert)
    DBI::dbHasCompleted(rs)
    DBI::dbGetRowsAffected(rs)
    DBI::dbClearResult(rs)

    tablename <- paste0("tmp_", tablename)

  }

  return(tablename)

}
