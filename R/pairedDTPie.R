library(plotly)
library(DT)
pairedDTPieUI <- function(id){
    ns <- NS(id)
    uiOutput(ns("DTPieUI"))
}

pairedDTPie <- function(input,output,session,
                        df,width_dt = 9,width_plot = 3){
    renderUI()
}