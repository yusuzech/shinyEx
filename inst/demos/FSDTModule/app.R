library(shiny)
library(shinyEx)
library(tidyverse)

ui <- fluidPage(
    FSDTModuleUI("plot")
)

server <- function(input, output, session) {
    data <- FSDTSampleData()
    
    table <- createFSTable(
        df = data$df,
        id = data$id,
        row_type = data$row_type,
        row_css = data$row_css
        
    )
    
    callModule(FSDTModule,"plot",df=table)
}

shinyApp(ui, server)