#' @import shiny
#' @importFrom graphics hist
#' @importFrom stats rnorm
#'
app_global <- function() {

  run.mode <- "standalone"
  on.website <- FALSE

  xwd <- here::here()

  if (on.website){
    wd <- "."
    sapply(list.files(file.path(wd, "functions"), full.names=TRUE), source)
  } else {
    #wd <- system.file("app", package = "inndxr")
    wd <- file.path(xwd, "inst/app")
  }

  servers_file <- file.path(wd, "data/servers.RData")
  init_file <- file.path(wd, "data/init.server.RData")

  message(servers_file)

  if(file.exists(servers_file)){
    load(file = servers_file)

    by_server <- servers %>% group_by(servername) %>% mutate(serverhead = servername) %>% nest()
  } else {
    #????
  }

  if(file.exists(init_file)){
    load(file = init_file)
    server <- init.server$server
  } else {
    init.server <- NULL
    #take the save bed, otherwise the connect will fail
    server = "Azure"
  }

  init.server$servers <- list(servers)

  init.server <- inndxr:::upd_server(init.server, server = server)



  # --- Static HTML --------------------------------------------------------------

  html.modal <- shiny::HTML('
                            <div class="modal fade" id="updown-modal" role="dialog" tabindex="-1" aria-labelledby="demo-default-modal" aria-hidden="true" style="display: none;">
                            <div class="modal-dialog">
                            <div class="modal-content">
                            <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span></button>
                            <h4 class="modal-title">Upload</h4>
                            </div>
                            <div class="modal-body">
                            <p>Upload and adjust your own data. <strong>Data is not stored</strong> and will be deleted after the session.</p>
                            <ul>
                            <li>XLSX and CSV are supported.</li>
                            <li>The first row contains headers.</li>
                            <li>The <strong>first column contains the time</strong> (for format, see table below), the second the data.</li>
                            <li>Only <strong>monthly</strong> and <strong>quarterly</strong> series can be ajusted.</li>
                            <li>Download a series for an example (below). The result can be uploadad again.</li>
                            </ul>
                            <table class="table  table-condensed" >
                            <thead>
                            <tr>
                            <th>time format</th>
                            <th>example</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                            <td>separation by colon, dash, or letter</td>
                            <td><code>2014:3, 2014:4</code>, <code>2014-3, 2014-4</code>, <code>2014Q3, 2014Q4</code>, <code>2014M3, 2014M4</code></td>
                            </tr>
                            <tr>
                            <td>first day of period, Excel date or character string</td>
                            <td><code>2014-03-01, 2014-04-01</code></td>
                            </tr>
                            </tbody>
                            </table>
                            <div class="btn btn-file btn-primary" >
                            <input id="iFile" name="file" type="file" accept=NULL>
                            <span>
                            Upload XLSX or CSV
                            </span>
                            </div>
                            </div>
                            <div class="modal-header">
                            <h4 class="modal-title">Download</h4>
                            </div>
                            <div class="modal-body">
                            <p>Download the series shown in the Output panel.</p>
                            <a id="oDownloadCsv" class="shiny-download-link btn btn-success" type="button" target="_blank">Download CSV</a>
                            <a id="oDownloadXlsx" class="shiny-download-link btn btn-success" type="button" target="_blank">Download XLSX</a>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>
                            </div>
                            <!-- /.modal-content -->
                            </div>
                            </div>
                            ')

  html.logo <- shiny::tags$span(class="logo", shiny::tags$b(style = "padding-right: 3px;", "Inndx"), shiny::tags$small("TDR"))

  # if (run.mode == "seasonal"){
  #   html.header <- shiny::tags$header(class="main-header",
  #     html.logo,
  #     shiny::tags$nav(class="navbar navbar-static-top", role="navigation",
  #       shiny::tags$span(style="display:none;",
  #         shiny::tags$i(class="fa fa-bars")
  #       ),
  #       shiny::tags$a(href="#", class="sidebar-toggle", `data-toggle`="offcanvas", role="button",
  #         shiny::tags$span(class="sr-only", "Toggle navigation")
  #       ),
  #       shiny::tags$div(class="navbar-custom-menu",
  #         shiny::tags$ul(class="nav navbar-nav",
  #           shiny::tags$li(shiny::tags$button(id="iOutput", href="#", type="button", style = "margin-right: 10px !important;",
  #                          class="btn btn-default btn action-button btn-navbar",
  #                     shiny::tags$i(class="fa fa-file-text-o", style = "padding-right: 6px;"), " X-13 Output"
  #                   )
  #           ),
  #           shiny::tags$li(shiny::tags$button(id="iReturn", href="#", type="button",
  #                          class="btn btn-warning btn action-button btn-navbar",
  #                     shiny::tags$i(class="fa fa-sign-out", style = "padding-right: 6px;"), "To Console"
  #                   )
  #           )
  #         )
  #       )
  #     )
  #   )
  # }


  # if (run.mode == "x13story"){
  #   html.header <- shiny::tags$header(class="main-header",
  #     html.logo,
  #     shiny::tags$nav(class="navbar navbar-static-top", role="navigation",
  #       shiny::tags$span(style="display:none;",
  #         shiny::tags$i(class="fa fa-bars")
  #       ),
  #       shiny::tags$a(href="#", class="sidebar-toggle", `data-toggle`="offcanvas", role="button",
  #         shiny::tags$span(class="sr-only", "Toggle navigation")
  #       ),
  #       shiny::tags$div(class="navbar-custom-menu",
  #         shiny::tags$ul(class="nav navbar-nav",
  #           shiny::tags$li(shiny::tags$button(id="iOutput", href="#", type="button",
  #                          class="btn btn-default btn action-button btn-navbar",
  #                     shiny::tags$i(class="fa fa-file-text-o", style = "padding-right: 6px;"), " X-13 Output"
  #                   )
  #           )
  #         )
  #       )
  #     )
  #   )
  # }


  # TDR Server Menu Items
  html_li_example <- function(id, title, body, icon, freq){
    shiny::tags$li(
      shiny::tags$a(class = "shiny-id-el", href="#", id = id,
                    shiny::tags$i(class=paste("fa fa-fw", icon)),
                    shiny::tags$h4(
                      title#,
                      # shiny::tags$small(
                      #   shiny::tags$i(class=paste("fa", "fa-clock-o")),
                      #   freq
                      # )
                    ),
                    shiny::tags$p(body)
      )
    )
  }

  server_li <- function(data){
    html_li_servers <- html_li_example(id = data$serverhead, title = data$serverhead, body = paste0("TDR Server : ", data$serverhead), icon = "fa-fighter-jet text-red")
    return(html_li_servers)
  }

  # by_server %>%
  #   mutate(
  #     li  = data %>% map(server_li)
  #   )

  ########################################################################

  if (run.mode == "standalone"){
    html.header <- shiny::tags$header(class="main-header",
                                      html.logo,
                                      shiny::tags$nav(class="navbar navbar-static-top", role="navigation",
                                                      shiny::tags$span(style="display:none;",
                                                                       shiny::tags$i(class="fa fa-bars")
                                                      ),
                                                      shiny::tags$a(href="#", class="sidebar-toggle", `data-toggle`="offcanvas", role="button",
                                                                    shiny::tags$span(class="sr-only", "Toggle navigation")
                                                      ),
                                                      shiny::tags$div(class="navbar-custom-menu",
                                                                      shiny::tags$ul(class="nav navbar-nav",
                                                                                     if (on.website){
                                                                                       shiny::HTML('<li><a href="http://www.seasonal.website"><strong>Workbench</strong></a></li>
                                                                                                   <li><a href="seasonal.html">Introduction</a></li>
                                                                                                   <li style=""><a href="examples.html">Examples</a></li>')
                                                                                     } else {
                                                                                       NULL
                                                                                     },
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
                                                                                                                                  shiny::tags$ul(class="menu",
                                                                                                                                                 ###MDT - Load various TDR servers
                                                                                                                                                 by_server$data %>% map(server_li)

                                                                                                                                  )
                                                                                                                   )
                                                                                                    )
                                                                                     ),
                                                                                     shiny::tags$li(shiny::tags$button(`data-target` = "#updown-modal",
                                                                                                                       `data-toggle` = "modal", type="button",
                                                                                                                       style = "margin-right: 10px !important;",
                                                                                                                       class="btn btn-success btn btn-navbar",
                                                                                                                       shiny::tags$i(class="fa fa-database", style = "padding-right: 6px;"), "Up-/Download"
                                                                                     )
                                                                                     )
                                                                      )
                                                      )
                                      )
  )
  }


}
