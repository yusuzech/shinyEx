library(plotly)
library(DT)
library(shinyjs)

# plotly line/pie chart controled by datatable

pairedDTPlotUI <- function(id){
    ns <- NS(id)
    uiOutput(ns("DTPlotUI"))
}

pairedDTPlot <- function(input,output,session,
                         df,
                         width_dt = 8, # table width
                         width_plot = 4, # graph width,
                         title = "", # title for the module
                         value_type = "general", #valid
                         direction = "v", #h & v for horizontal and vertical
                         h_ignore_columns = NULL, # column names to igonore when plotting horizontally
                         height = "300px",
                         server = FALSE # table on server side
){
    # detect if need to hide the bar chart
    if((direction == "v") & (value_type %in% c("percent","percentage"))){
        plot_visibility <- "hidden"
    } else {
        plot_visibility <- "visible"
    }
    # renderUI first.
    output$DTPlotUI <- renderUI({
        ns <- session$ns
        div(
            fluidRow(tags$h4(title)),
            fluidRow(
                column(
                    width = width_dt,
                    div(
                        style = "font-size:75%;",
                        DT::DTOutput(ns("DTPlotDT"))
                    )
                ),
                column(
                    width = width_plot,
                    div(
                        style = paste0("visibility:",plot_visibility,";"),
                        plotlyOutput(ns("DTPlotPlot"))
                    )
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
        plot_y_tick_foramt <- "$"
        
    } else if (value_type %in% c("percentage","percent")){
        dt_format_func <- function(table,columns){
            DT::formatPercentage(
                table,
                columns,
                digits = 2
            )
        }
        plot_y_tick_foramt <- "%"
        
    } else {
        dt_format_func <- function(table,columns){
            DT::formatRound(
                table,
                columns,
                digits = 2
            )
        }
        plot_y_tick_foramt <- ".2"
    }
    
    # plot by row or column?
    if(direction == "h"){
        dt_target <- "row"
        dt_mode = "multiple"
    } else if (direction == "v"){
        dt_target <- "column"
        dt_mode = "single"
    } else {
        stop("Direction can only be h or v")
    }
    
    output$DTPlotDT <- renderDataTable({
        DT::datatable(
            df[,-1],
            rownames = row_names,
            selection = list(target = dt_target,mode = dt_mode,selected = 1),
            options = list(
                scrollX = TRUE,
                scrollY = height,
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
    },server = server)
    
    # plotly pie chart
    observeEvent(c(
        input$DTPlotDT_columns_selected,
        input$DTPlotDT_rows_selected
    ),{
        if(direction == "v"){
            plot_data <- data.frame(
                label = row_names,
                value = df[,1+input$DTPlotDT_columns_selected]
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
            output$DTPlotPlot <- renderPlotly(p)
        } else if(direction == "h"){
            # req(!is.null(input$DTPlotDT_rows_selected))
            # filter column names
            df <- df[,colnames(df)[!(colnames(df) %in% h_ignore_columns)]]
            plot_data <- df %>%
                dplyr::filter(row_number() %in% input$DTPlotDT_rows_selected)
            # convert data frame to traces
            x_labels <- colnames(plot_data)[-1]
            x_values <- seq_along(x_labels)
            y_traces <- pmap(unname(plot_data),function(name,...){
                list(
                    name = name,
                    value = unlist(list(...))
                )
            })
            
            p <- plot_ly(type = "scatter", mode  = "lines")
            for(y_trace in y_traces){
                p <- p %>%
                    add_trace(x = x_values,
                              y = y_trace$value,
                              name = y_trace$name)
            }
            p <- p %>%
                layout(
                    showlegend = F,
                    xaxis = list(
                        ticktext = x_labels,
                        tickvals = x_values,
                        tickmode = "array"
                    ),
                    yaxis = list(
                        tickformat = plot_y_tick_foramt
                    )
                )
            output$DTPlotPlot <- renderPlotly(p)
        }
    })
    
}
