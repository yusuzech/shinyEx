library(shiny)
library(DT)
shinyApp(
    ui = basicPage(
        actionButton("show", "Show modal dialog")
    ),
    server = function(input, output) {
        observeEvent(input$show, {
            showModal(modalDialog(
                title = "Important message",
                renderDataTable(iris)
            ))
        })
    }
)