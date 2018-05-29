# Naming convention :
# all Shinymodule have to begin with `mod_`, in lowercase Except for `UI` , `Input` and `Output`
# use `Input` as sufix if your module is an Input
# use `Output` as sufix if your module is an Output
# use `UI` as sufix if your module is both Input and Output
#
# examples :
# ui side : mod_truc_bidulUI
# server side : mod_truc_bidul
#
# ui side : mod_machin_chouetteInput
# server side : mod_machin_chouette

# all shinyModule must have a documentation page
# one unique page for both ui and server side ( you can use `#' @rdname` to link both function)

# A minimalist example is mandatory

#' @title   mod_tdr_serversUI and mod_tdr_servers
#' @description  A shiny Module
#'
#' @param id shiny id
#' @param label fileInput label
#'
#' @export
#' @examples
#' library(shiny)
#' library(DT)
#' if (interactive()){
#' ui <- fluidPage(
#'   mod_tdr_serversUI("fichier"),
#' DTOutput("tableau")
#' )
#'
#' server <- function(input, output, session) {
#'   data <- callModule(mod_csv_file,"fichier")
#'   output$tableau <- renderDT({data()})
#' }
#'
#' shinyApp(ui, server)
#' }
#'
mod_tdr_serversUI <- function(id, title, body) {
  ns <- NS(id)

  tagList(

    shiny::tags$ul(id = "iExample", class="shiny-id-callback dropdown-menu",
                   shiny::tags$li(class="header", "TDR Servers"),
                   shiny::tags$li(style="position: relative; overflow: hidden; width: auto; height: 200px;",
                                  shiny::tags$ul(class="menu", inndxrs:::servers_dropdown())
                                  )

                )
  )

}


#' mod_tdr_company server function
#'
#' @param input internal
#' @param output internal
#' @param session internal
#' @param stringsAsFactors logical: should character vectors be converted to factors?
#'
#' @importFrom glue glue
#' @export
#' @rdname mod_tdr_companyUI
mod_tdr_servers <- function(input, output, session, stringsAsFactors=TRUE) {

  company <- reactive({
    validate(need(input$tabcompany, message = FALSE))
    input$tabcompany
  })

  observe({
    message( glue::glue("File {company()$name} uploaded" ) )
  })

  ac <- inndxrs:::createTdrContext(configFile = getOption("inndxrs.config"), svrname = "")
  servers <- tibble::as_tibble(ac$tdrservers) %>% dplyr::select(servername, database)

  dataframe <- reactive({
    servers
  })

  dataframe
}
