#' pairedDTPlotUI
#' @export
pairedDTPlotlyModuleUI <- function(id){
    ns <- NS(id)
    uiOutput(ns("DTPlotUI"))
}

#' pairedDTplot Server
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#' @param df data frame to use. The first column should be identifiers, other columns
#' should be values used for plotting
#' @param width_dt width of DT, should be between 1 to 12
#' @param width_plot width of plotly plot, should be between 1 to 12
#' @param title title for the module
#' @param value_type default to "none", how the values in data frame should be 
#' formatted. See more in details
#' @param direction "v" or "h" plot horizontally or vertically. See more in details
#' @param h_ignore_columns When plotting ,whether to ignore listed columns.
#' @param h_reverse whether to reverse graph when ploting horizontally
#' @param height height of DT in module, in pixels
#' @param server for DT, whether to use server side processing
#' 
#' @return DT table and plotly graph
#' 
#' @details 
#' \code{value_type}:
#' \itemize{
#'     \item none: no extra formatting
#'     \item currency: dollar sign prefix, digits round to 0
#'     \item percent: percentage sign suffix, digits round to 2
#'     \item general: digits round to 2
#' }
#' 
#' \code{direction}:
#' \itemize{
#'     \item v: select and create pie chart using columns
#'     \item h: select and create line chart using rows
#' }
#' 
#' @examples 
#' \dontrun{
#' # See demo:
#' runDemoPairedDTplotlyModule()
#' }
#'
#' @export
pairedDTPlotlyModule <- function(input,output,session,
                         df,
                         width_dt = 8, # table width
                         width_plot = 4, # graph width,
                         title = "", # title for the module
                         value_type = "none", #valid
                         direction = "v", #h & v for horizontal and vertical
                         h_ignore_columns = NULL, # column names to igonore when plotting horizontally
                         h_reverse = FALSE, # reverse ehen plotting horizontally?
                         height = "300px",
                         server = FALSE # table on server side
){
    # validate user input
    numeric_columns <- purrr::map_lgl(df[,2:ncol(df),drop = FALSE],is.numeric)
    if(!all(numeric_columns)){
        msg <- paste("Following columns must be numerical:",
                     paste0(colnames(df)[!numeric_columns],collapse = ","))
        stop(msg)
    }
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
            style = "margin-left:25px",
            fluidRow(
                tags$h4(title),
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
    
    df[,1] <- as.character(unlist(df[,1,drop = FALSE]))
    # all columns except the first one should be numeric
    stopifnot(purrr::map_lgl(df[,-1],is.numeric))
    col_names <- colnames(df)[-1]
    row_names <- unlist(df[,1,drop = FALSE])
    
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
        
        plot_y_tick_foramt <- "$,.0f"
        
        number_format_func <- function(x){
            formattable::currency(x,digits = 0)
        }
        
    } else if (value_type %in% c("percentage","percent")){
        dt_format_func <- function(table,columns){
            DT::formatPercentage(
                table,
                columns,
                digits = 2
            )
        }
        
        plot_y_tick_foramt <- "%.2f"
        
        number_format_func <- function(x){
            x
        }
        
        
    } else if (value_type %in% "general") {
        dt_format_func <- function(table,columns){
            DT::formatRound(
                table,
                columns,
                digits = 2
            )
        }
        
        plot_y_tick_foramt <- ".2f"
        
        number_format_func <- function(x){
            formattable::comma(x,digits = 2)
        }
    } else {
        dt_format_func <- function(table,...){
            table
        }
        
        plot_y_tick_foramt <- "NULL"
        
        number_format_func <- function(x){
           x
        }
        
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
    
    # + datatable ----
    output$DTPlotDT <- renderDataTable({
        DT::datatable(
            df[,-1,drop = FALSE],
            rownames = row_names,
            selection = list(target = dt_target,mode = dt_mode,selected = 1),
            extensions = "Buttons",
            options = list(
                scrollX = TRUE,
                scrollY = height,
                dom = "Bftp",
                buttons = list(
                    list(
                        extend = "collection",
                        text = 'Deselect All',
                        action = DT::JS("function ( e, dt, node, config ) {
                                    dt.rows('.selected')
                                        .nodes()
                                        .to$()
                                        .removeClass('selected');
                                }")
                    )
                )
            )
        ) %>%
            dt_format_func(
                columns = col_names
            ) %>%
            DT::formatStyle(
                columns = col_names,
                color = DT::styleInterval(1e-5,c("red","black"))
            )
    },server = server)
    
    observeEvent(c(
        input$DTPlotDT_columns_selected,
        input$DTPlotDT_rows_selected
    ),{
        
        # + plotly pie chart ----
        if(direction == "v"){
            selected_column <- ifelse(
                is.null(input$DTPlotDT_columns_selected),
                1,
                input$DTPlotDT_columns_selected
            )
            plot_data <- data.frame(
                label = unname(row_names),
                value = unname(unlist(df[,1+selected_column,drop=FALSE]))
            )
            p <- plot_ly(
                data = plot_data,
                labels = ~label,
                values  = ~value,
                type = "pie",
                hoverinfo = "labels"
            ) %>%
                layout(
                    showlegend = F,
                    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
                )
            output$DTPlotPlot <- renderPlotly(p)
        } else if(direction == "h"){
            # + plotly line chart ----
            # filter column names
            
            df <- df[,colnames(df)[!(colnames(df) %in% h_ignore_columns)]]
            plot_data <- df %>%
                dplyr::filter(row_number() %in% input$DTPlotDT_rows_selected)
            # convert data frame to traces
            if(h_reverse){
                x_labels <- rev(colnames(plot_data)[-1])
                x_values <- seq_along(x_labels)
                y_traces <- pmap(unname(plot_data),function(name,...){
                    list(
                        name = name,
                        value = rev(unlist(list(...)))
                    )
                })
            } else {
                x_labels <- colnames(plot_data)[-1]
                x_values <- seq_along(x_labels)
                y_traces <- pmap(unname(plot_data),function(name,...){
                    list(
                        name = name,
                        value = unlist(list(...))
                    )
                })
            }
            
            p <- plot_ly(type = "scatter", 
                         mode  = "lines")
            for(y_trace in y_traces){
                p <- p %>%
                    add_trace(x = x_values,
                              y = y_trace$value,
                              name = y_trace$name,
                              hoverinfo = "text",
                              text = glue("{x_labels}
                                           {number_format_func(y_trace$value)}
                                           {y_trace$name}"))
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
            req(p)
            output$DTPlotPlot <- renderPlotly(p)
        }
    })
}