library(tidyverse)
library(shiny)
library(plotly)
library(DT)
library(reshape2)
library(shiny)
library(shinydashboard)
source("../../../R/pairedDTPie.R")

data <- reshape2::dcast(diamonds,clarity ~ color,value.var = "x",fun.aggregate = mean)

ui <- fluidPage(
    pairedDTPieUI("test")
)

server <- function(input, output, session) {
  callModule(module = pairedDTPie,
             id = "test",
             df = data,
             )
}

shinyApp(ui, server)