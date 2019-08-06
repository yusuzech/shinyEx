library(shiny)
library(shinyjs)
source("../../../R/arrowButtonGroup.R")

ui <- fluidPage(
  fluidRow("test:"),
  useShinyjs(),
  fluidRow(arrowButtonGroupUI("test"))
)

server <- function(input, output, session) {
  callModule(module = arrowButtonGroup,id = "test")
}

shinyApp(ui, server)