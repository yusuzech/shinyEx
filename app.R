library(shiny)
library(shinyModulesEx)
ui <- fluidPage(
    arrowButtonGroupInput("test",
                                          type = "h",
                                          size = "200%",
                                          color = "blue",
                                          colorClick = "red")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)