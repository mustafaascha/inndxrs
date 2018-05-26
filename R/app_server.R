#' @import shiny
#' @importFrom graphics hist
#' @importFrom stats rnorm
#'
app_server <- function(input, output,session) {

  # if ( app_prod() ){message("prod mode")}else{message("dev mode")}
  # output$distPlot <- renderPlot({
  #   x    <- rnorm(1000)
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
  #   hist(x, breaks = bins, col = 'darkgray', border = 'white')
  # })
  #
  # data <- callModule(mod_csv_file,"fichier")
  # output$tableau <- DT::renderDT({data()})


  senv <- environment()  # the session environment

  rUplMsg <- reactiveValues(upd = 0)
  rError <- reactiveValues(msg = "")
  rServer <- reactiveValues(server = init.server, senv = senv)

    # a function with reactive consequences. Must be inside shinyServer()
  upd_or_fail <- function(z){
    if (inherits(z, "try-error")){
      rError$msg <- z
    } else {
      rServer$server <- z
      rError$msg <- ""
    }
  }


  # selectors updated by rModel
  output$oFOpts <- shiny::renderUI({

    m <- rServer$server

    cc <- m$tdr[[1]] %>% unnest() %>%
      select(
        CompanyName, ObelixDatabaseName
      ) %>% split(.$CompanyName)


    a <- shiny::selectInput("iObxdbs", "Companies", choices = cc, selected = NULL, width = "240px")
    return(a)

  })

  output$oMainTable <- DT::renderDataTable({
    sub_data <- servers
    DT::datatable(sub_data, rownames = FALSE)
  }, server = TRUE)


  # show error msg on error
  shiny::observe({
    if (rError$msg == "") return(NULL)
    rawerr <- inndxr:::err_to_html(rError$msg)
    irev <- shiny::HTML('<button id="iRevert" type="button" class="btn action-button btn-danger" style = "margin-right: 4px; margin-top: 10px;">Revert</button>')
    error.id <<- shiny::showNotification(shiny::HTML(rawerr), action = irev, duration = NULL, type = "error")
  })

  # remove error msg if error is gone
  shiny::observe({
    if (rError$msg != "") return(NULL)
    if (exists("error.id"))
      removeNotification(error.id)
  })

  shiny::observe({
    server <- input$iExample[1]
    m <- shiny::isolate(rServer$server)

    #message(server)

    if (!is.null(server)){
      z <- inndxr:::upd_server(m, server = server)
      upd_or_fail(z)
    }
  })

}
