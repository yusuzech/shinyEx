library(tidyverse)
library(shiny)
library(plotly)
library(DT)
library(reshape2)
library(shiny)
library(shinydashboard)
source("../../../R/pairedDTPlot.R")

data <- reshape2::dcast(diamonds,clarity ~ color,value.var = "x",fun.aggregate = mean) %>%
    mutate(clarity = as.character(clarity))

ui <- fluidPage(
    pairedDTPlotUI("test")
)

server <- function(input, output, session) {
  callModule(module = pairedDTPlot,
             id = "test",
             df = data,
             direction = "h",
             value_type = "money",
             h_ignore_columns = "D"
             )
}

shinyApp(ui, server)