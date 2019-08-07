library(shiny)
library(shinyModulesEx)

ui <- fluidPage(
  arrowButtonGroupInput(inputId = "test1",type = "h",origin = 1L),
  tags$h4("Value:"),
  textOutput("test11"),
  tags$br(),

  arrowButtonGroupInput(inputId = "test2",type = "v",origin = 5L),
  tags$h4("Value:"),
  textOutput("test21"),
  tags$br(),
  
  arrowButtonGroupInput(inputId = "test3",type = "a",origin = c(0L,2L)),
  tags$h4("Value:"),
  textOutput("test31"),
  tags$br()
)

server <- function(input, output, session) {
    observe({
        output$test11 <- renderText(input$test1)
        output$test21 <- renderText(input$test2)
        output$test31 <- renderText(input$test3)
    })
}

shinyApp(ui, server)