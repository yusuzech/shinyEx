library(plotly)
library(DT)
library(shinydashboard)

pairedDTPieUI <- function(id){
    ns <- NS(id)
    uiOutput(ns("DTPieUI"))
}

pairedDTPie <- function(input,output,session,
                        df,
                        width_dt = 8, # table width
                        width_plot = 4, # graph width,
                        title = "Diamonds",
                        value_type = "general", #valid
                        collapsed = TRUE,
                        status = "info"
){
    # renderUI first.
    output$DTPieUI <- renderUI({
        ns <- session$ns
        shinydashboard::box(
            width = 12,
            title = title,
            solidHeader = TRUE,
            collapsible = TRUE,
            collapsed = collapsed,
            status = status,
            fluidRow(
                column(
                    width = width_dt,
                    div(
                        style = "font-size:75%;",
                        DT::DTOutput(ns("DTPieDT"))
                    )
                ),
                column(
                    width = width_plot,
                    plotlyOutput(ns("DTPiePie"))
                )
            )
        )
    })
    
    # convert first column to character
    df[,1] <- as.character(df[,1])
    # print(df)
    # all columns except the first one should be numeric
    stopifnot(purrr::map_lgl(df[,-1],is.numeric))
    col_names <- colnames(df)[-1]
    row_names <- df[,1]
    # print(df[,1])
    
    # format function depented on input type ----
    if(value_type %in% c("currency","money")){
        dt_format_func <- function(table,columns){
            DT::formatCurrency(
                table,
                columns,
                currency = "$",
                digits = 0
            )
        }
    } else if (value_type %in% c("percentage","percent")){
        dt_format_func <- function(table,columns){
            DT::formatPercentage(
                table,
                columns,
                digits = 2
            )
        }
    } else {
        dt_format_func <- function(table,columns){
            DT::formatRound(
                table,
                columns,
                digits = 2
            )
        }
    }
    
    output$DTPieDT <- renderDataTable({
        DT::datatable(
            df[,-1],
            rownames = row_names,
            selection = list(target = 'column',mode = "single",selected = 1),
            options = list(
                scrollX = TRUE,
                scrollY = "400px",
                dom = "tp"
            )
        ) %>%
            dt_format_func(
                columns = col_names
            ) %>%
            DT::formatStyle(
                columns = col_names,
                color = DT::styleInterval(0.5,c("red","black"))
            )
    })
    
    # plotly pie chart
    observeEvent(input$DTPieDT_columns_selected,{
        req(!is.null(input$DTPieDT_columns_selected))
        
        plot_data <- data.frame(
            label = row_names,
            value = df[,1+input$DTPieDT_columns_selected]
        )
        
        p <- plot_ly(
            data = plot_data,
            labels = ~label,
            values  = ~value,
            type = "pie"
        ) %>%
            layout(
                showlegend = F,
                xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
            )
        output$DTPiePie <- renderPlotly(p)
    })
    
}
