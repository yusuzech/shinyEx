library(tidyverse)
library(shiny)
library(plotly)
library(DT)
library(reshape2)
library(shiny)
source("../../../R/pairedDTPie.R")

data <- reshape2::dcast(diamonds,clarity ~ color,value.var = "x",fun.aggregate = mean)

ui <- fluidPage(
    pairedDTPieUI("test")
)

server <- function(input, output, session) {
  callModule(pairedDTPie,"test",11,1)
}

shinyApp(ui, server)