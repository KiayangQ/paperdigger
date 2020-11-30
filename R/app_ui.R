#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    # golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      titlePanel("Paper Digger"),
      sidebarLayout(
        sidebarPanel(
          fileInput("files",label = "Input meta data",accept = c(".ris",".bib")),
          textInput('sci',label = "Input sci_hub url"),
          radioButtons("source",label="Select data source",choices = c("Dois","Database"),selected = "Database"),
          actionButton("load",label = "Load"),
          actionButton("reset",label = "Reset")
        ),
        mainPanel(
          tags$div(id = "placeholder")
        )
      )
    )
  )
}

#' #' Add external Resources to the Application
#' #' 
#' #' This function is internally used to add external 
#' #' resources inside the Shiny application. 
#' #' 
#' #' @import shiny
#' #' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' #' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'paperdigger'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

