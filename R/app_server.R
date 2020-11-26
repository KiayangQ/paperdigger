#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny httr dplyr stringr purrr
#' @importFrom tidyr separate
#' @noRd
#' 
app_server <- function(input, output, session) {
  # List the first level callModules here
  data1 <- eventReactive(input$load,{
    req(input$files)
    if (input$sci==""){
      len <- read_bib(input$files$datapath,original=input$source)
      withProgress(message="working...",min=0,value=0,max=length(len$dois),expr = {
          sci_loc(input$files$datapath,original=input$source)    
        })
    }else{
      withProgress(message="working...",min=0,value=0,max=length(read_bib(input$files$datapath,original=input$source)$dois),expr = {
          sci_loc(input$files$datapath,input_url=input$sci,original=input$source)    
      })
      }
  })
  
  observeEvent(input$load, {
      insertUI("#placeholder", "afterEnd", ui = dataTableOutput('table'))
  })
  
  
  observeEvent(input$reset,{
    removeUI("#table")
    
  })
  
  output$table <- renderDataTable({
    
    data1()[[2]]
  })
  
}

