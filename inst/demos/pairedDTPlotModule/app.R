library(shiny)
library(plotly)
library(DT)
library(glue)
library(shinyModulesEx)
library(dplyr)
library(purrr)

data <- structure(list(clarity = c("I1", "SI2", "SI1", "VS2", "VS1", 
                   "VVS2", "VVS1", "IF"), D = c(6450, 5960, 5460, 5160, 5250, 5050, 
                    4890, 5590), E = c(6490, 6100, 5580, 5260, 5210, 4870, 4720, 
                   4960), F = c(6430, 6240, 5820, 5510, 5500, 5230, 4940, 4830), 
                   G = c(6670, 6380, 5830, 5760, 5580, 5390, 5060, 4940), H = c(7040, 
                    6740, 6210, 5980, 5620, 5150, 4910, 4980), I = c(7030, 7010, 
                     6360, 6330, 5960, 5430, 5130, 5000), J = c(7380, 7070, 6580, 
                    6480, 6190, 6250, 5800, 5420)), class = "data.frame", row.names = c(NA,-8L))

ui <- fluidPage(
    fluidRow(
        column(
            width = 4,
            selectInput(
                inputId = "selectDirection",
                label = "Select Plot Direction",
                choices = c("h","v"),
                selected = "h"
            )
        ),
        column(
            width = 4,
            selectInput(
                inputId = "selectFormat",
                label = "Select Data Foramt",
                choices = c("currency","percent","general"),
                selected = "currency"
            )
        ),
        column(
            width = 4,
            selectInput(
                inputId = "ignoreColumns",
                label = "Ignore Columns(when plot horizontally)",
                choices = c("",colnames(data)[-1]),
                selected = "",
                multiple = TRUE
            )
        )
    ),
    fluidRow(pairedDTPlotModuleUI("test"))
)

server <- function(input, output, session) {
    
    observeEvent(c(
        input$selectDirection,
        input$selectFormat,
        input$ignoreColumns
    ),{
        callModule(module = pairedDTPlotModule,
                   id = "test",
                   df = data,
                   direction = input$selectDirection,
                   value_type = input$selectFormat,
                   h_ignore_columns = input$ignoreColumns
        )
    })
}

shinyApp(ui, server)