library(shiny)
library(shinyModulesEx)

ui <- fluidPage(
  fluidRow("test:"),
  fluidRow(arrowButtonGroupInput(inputId = "test",type = "a",size = "200%",start = c(0L,0L)))
)

server <- function(input, output, session) {
}

shinyApp(ui, server)