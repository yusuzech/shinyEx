library(shiny)
library(shinyModulesEx)
ui <- fluidPage(
    arrowButtonGroupInput("test",
                          type = "a",
                          color = "blue",
                          colorClick = "red")
)

server <- function(input, output, session) {
  observeEvent(input$test,{
      print(input$test)
  })
}

shinyApp(ui, server)