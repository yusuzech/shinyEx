library(shiny)
library(shinyEx)
choices <- letters
selected <- "f"

ui <- fluidPage(
    selectArrowInputModuleUI(inputId = "test"),
    tags$h4("Attributed selected:"),
    tags$p("Can be controlled by both selectInput and arrowButtonInput"),
    textOutput("textOut")
)

server <- function(input, output, session) {
    a <- callModule(module = selectArrowInputModule,
                         id = "test",
                         label = "Test",choices = choices,selected = selected)
    output$textOut <- renderText(a())

}

shinyApp(ui, server)

