
#' @import shiny
app_ui <- function() {
  shinydashboard::dashboardPage(
    inndxrs:::app_header(),
    shinydashboard::dashboardSidebar(disable = FALSE),
    shinydashboard::dashboardBody(
      shiny::tags$head(
        shiny::tags$link(rel = "stylesheet", type = "text/css", href = "docs.css"),
        shiny::tags$script(src = "shinyIDCallback.js")
      ),

      shiny::fluidRow(

        shiny::column(4,
                      shiny::uiOutput("oStory"),
                      shinydashboard::box(title = "Options", uiOutput("oFOpts"), width = NULL,
                                          collapsible = TRUE, collapsed = TRUE),
                      shinydashboard::tabBox(
                        title = shiny::tagList(shiny::actionButton("iStatic", "Static", shiny::tags$i(class="fa fa-magic", style = "padding-right: 6px;"), class = "btn", style = "margin-right: 4px; margin-bottom: 3px;"),
                                               shiny::actionButton("iEvalCall", "Run Call", class = "btn btn-primary", shiny::tags$i(class="fa fa-play-circle-o", style = "padding-right: 6px;"), style = "color: #fff; margin-bottom: 3px; margin-right: -3px;")
                        ),
                        id = "iActiveTerminal",
                        shiny::tabPanel("XXX",
                                        shiny::uiOutput("oTerminal")
                        ),
                        shiny::tabPanel("YYY",
                                        shiny::uiOutput("oTerminalX13")
                        ),
                        width = NULL
                      )
        ),

        shiny::column(8,
                      tags$div(id="output-box", class="box",
                               tags$div(class = "box-header with-border"
                                        ### Multilevel Dropdown on Graph
                                        #tags$h3(class = "box-title", uiOutput("oViewSelect")),
                                        #HTML('<small hidden id = "info-zoom" class = "pull-right text-muted">click and drag to zoom &mdash; double-click to restore</small>')
                               ),
                               tags$div(class = "box-body",
                                        #dygraphs::dygraphOutput("oMainPlot")
                                        DT::dataTableOutput("oMainTable")
                               ),
                               tags$div(class = "box-footer",
                                        shiny::uiOutput("oLabel")
                               )
                      ),
                      shinydashboard::box(title = "Summary",
                                          verbatimTextOutput("tbl")
                                          # shiny::fluidRow(
                                          #   shiny::column(4, shiny::uiOutput("oSummaryCoefs")),
                                          #   shiny::column(4, shiny::uiOutput("oSummaryStats")),
                                          #   shiny::column(4, shiny::uiOutput("oSummaryTests"))
                                          # )
                                          , width = NULL
                      )
        )

      ),

      # additional stuff at the end
      # html.modal,
      shiny::tags$script(src = "docs.js")
      # if (on.website){
      #   ga
      # } else {
      #   NULL
      # }

    ),
    title = "inndxr: TDR Interface",
    skin = "black"
  )

}

app_logo <- function() {
  html.logo <- shiny::tags$span(class="logo", shiny::tags$b(style = "padding-right: 3px;", "Inndx"), shiny::tags$small("TDR"))
  return(html.logo)
}

app_header <- function() {

  html.header <- shiny::tags$header(class="main-header",
                                    inndxrs:::app_logo(),
                                    shiny::tags$nav(class="navbar navbar-static-top", role="navigation",
                                                    shiny::tags$span(style="display:none;",
                                                                     shiny::tags$i(class="fa fa-bars")
                                                    ),
                                                    shiny::tags$a(href="#", class="sidebar-toggle", `data-toggle`="offcanvas", role="button",
                                                                  shiny::tags$span(class="sr-only", "Toggle navigation")
                                                    ),
                                                    shiny::tags$div(class="navbar-custom-menu",
                                                                    shiny::tags$ul(class="nav navbar-nav",
                                                                                   shiny::HTML('<li><a href="http://www.seasonal.website"><strong>Workbench</strong></a></li>
                                                                                               <li><a href="seasonal.html">Introduction</a></li>
                                                                                               <li style=""><a href="examples.html">Examples</a></li>'),
                                                                                   # Exampe Menu
                                                                                   shiny::tags$li(class="dropdown messages-menu",
                                                                                                  shiny::tags$a(href="#", class="dropdown-toggle", `data-toggle`="dropdown",
                                                                                                                style = "border-right: 1px solid #eee; margin-right: 10px;",
                                                                                                                shiny::tags$i(class="fa fa-line-chart"),
                                                                                                                shiny::tags$span(class="label label-danger", "4")
                                                                                                  ),
                                                                                                  shiny::tags$ul(id = "iExample", class="shiny-id-callback dropdown-menu",
                                                                                                                 shiny::tags$li(class="header", "TDR Servers"),
                                                                                                                 shiny::tags$li(style="position: relative; overflow: hidden; width: auto; height: 200px;",
                                                                                                                                shiny::tags$ul(class="menu", inndxrs:::servers_dropdown())
                                                                                                                                )
                                                                                                  )
                                                                                   ),
                                                                                   shiny::tags$li(shiny::tags$button(`data-target` = "#updown-modal",
                                                                                                                     `data-toggle` = "modal", type="button",
                                                                                                                     style = "margin-right: 10px !important;",
                                                                                                                     class="btn btn-success btn btn-navbar",
                                                                                                                     shiny::tags$i(class="fa fa-database", style = "padding-right: 6px;"), "Up-/Download"))
                                                                                   )
                                                                    )
                                    )
  )

  return(html.header)

}


html_li_example <- function(id, title, body, icon, freq){
  shiny::tags$li(
    shiny::tags$a(class = "shiny-id-el", href="#", id = id,
                  shiny::tags$i(class=paste("fa fa-fw", icon)),
                  shiny::tags$h4(
                    title
                  ),
                  shiny::tags$p(body)
    )
  )
}

server_li <- function(data){
  html_li_servers <- inndxrs:::html_li_example(id = data$serverhead, title = data$serverhead, body = paste0("TDR Server : ", data$serverhead), icon = "fa-fighter-jet text-red")
  return(html_li_servers)
}

servers_dropdown <- function() {
  ac <- createTdrContext(configFile = getOption("inndxrs.config"), svrname = "")
  servers <- tibble::as_tibble(ac$tdrservers)
  by_server <- servers %>% dplyr::group_by(servername) %>% dplyr::mutate(serverhead = servername) %>% tidyr::nest()
  ret <- by_server$data %>% purrr::map(inndxrs:::server_li)

  return(ret)
}



