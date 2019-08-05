library(tidyverse)
library(shiny)
library(plotly)
library(DT)
library(reshape2)
library(shiny)
# library(shinydashboard)
library(glue)
source("../../../R/pairedDTPlot.R")

data <- reshape2::dcast(diamonds,clarity ~ color,value.var = "x",fun.aggregate = mean) %>%
    mutate(clarity = as.character(clarity)) %>%
    mutate_if(is.numeric,~1000*round(.x,2)) 

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
    fluidRow(pairedDTPlotUI("test"))
)

server <- function(input, output, session) {
    
    observeEvent(c(
        input$selectDirection,
        input$selectFormat,
        input$ignoreColumns
    ),{
        callModule(module = pairedDTPlot,
                   id = "test",
                   df = data,
                   direction = input$selectDirection,
                   value_type = input$selectFormat,
                   h_ignore_columns = input$ignoreColumns
        )
    })
}

shinyApp(ui, server)