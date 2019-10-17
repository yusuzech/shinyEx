library(shiny)
library(shinyEx)

ui <- fluidPage(
  fluidRow(
    column(
      width = 4,
      wellPanel(
        arrowButtonGroupInput(inputId = "test1",type = "h"),
        textOutput("test11")
      )
    ),
    column(
      width = 4,
      wellPanel(
        arrowButtonGroupInput(inputId = "test2",type = "v"),
        textOutput("test21")
      )
    ),
    column(
      width = 4,
      wellPanel(
        arrowButtonGroupInput(inputId = "test3",type = "a"),
        textOutput("test31")
      )
    )
  )
)

server <- function(input, output, session) {
  observe({
    output$test11 <- renderText(input$test1)
  })

  observe({
    output$test21 <- renderText(input$test2)
  })
  
  observe({
    output$test31 <- renderText(input$test3)
  })
}

shinyApp(ui, server)