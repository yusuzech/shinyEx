library(shiny)
library(shinyModulesEx)

ui <- fluidPage(
  fluidRow("test:"),
  fluidRow(arrowButtonGroupInput(inputId = "test",type = "h",size = "200%"))
)

server <- function(input, output, session) {
}

shinyApp(ui, server)