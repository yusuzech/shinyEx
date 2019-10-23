#' filter then group then aggregate then pivot a data frame
#' 
fgap_df <- function(df,filters = NULL,group_col,value_col,agg_fn=sum,
                 pivot_col = NULL,pivot_fill = NA,transpose = FALSE){
    # filter data frame
    if (length(filters) > 0) {
        for(i in 1:length(filters)){
            df <- df[as.vector(df[,names(filters)[i]] == filters[[i]]),]
        }
    }
    # group data frame
    df <- df %>%
        dplyr::group_by_at(c(group_col,pivot_col)) %>%
        dplyr::summarise_at(value_col,agg_fn)
    
    if (is.null(pivot_col)) {
        return(df)
    } else {
        if (transpose) {
            return(
                tidyr::pivot_wider(
                    data = df,
                    id_cols = !!sym(pivot_col),
                    names_from = !!sym(group_col),
                    values_from = !!sym(value_col),
                    values_fill = setNames(list(pivot_fill),value_col)
                )
            )
        } else {
            return(
                tidyr::pivot_wider(
                    data = df,
                    id_cols = !!sym(group_col),
                    names_from = !!sym(pivot_col),
                    values_from = !!sym(value_col),
                    values_fill = setNames(list(pivot_fill),value_col)
                )
            )
        }
    }
        
}

#' UI for drillDTModalModule
#' @export
drilldownDTModuleUI <- function(id){
    ns <- NS(id)
    shiny::uiOutput(ns("dddt"))
}


#' server for drillDTModalModule
#' @export
drilldownDTModule <- function(input,output,session,
                             longdf,
                             type = c("box","modal"),
                             level_cols,
                             value_col,
                             agg_fn = sum,
                             pivot_col = NULL,
                             pivot_fill = NA,
                             transpose = FALSE,
                             options = NULL
) {
    # initialize default esthetic settings
    opts <- list(
        box = list(
            title = "",
            width = 12,
            height = NULL,
            side = "left"
        ),
        dt = list(
            
        )
    )
    # over writing user provided settings
    if (!is.null(options) & is.list(options)) {
        argdif <- setdiff(names(unlist(options)),names(unlist(opts)))
        if (length(argdif) > 0) {
            message(paste("options in drilldownDTModule:",
                          paste0(argdif,collapse = ", ")," not recognized."))
        }
        opts <- modifyList(opts,options)
    }
    # initialize UI
    ns <- session$ns
    if(type[1] == "box"){
        output$dddt <- renderUI({
            do.call(tabBox, c(
                Map(function(i) {
                    tabPanel(
                        title = paste0(level_cols[i]),
                        value = paste0('level',i-1),
                        DT::dataTableOutput(ns(paste0('level',i-1)))
                    )
                },seq_along(level_cols)),
                id = ns("drilldownbox"),
                title = opts$box$title,
                width = opts$box$width,
                height = opts$box$height,
                side = opts$box$side
            ))
        })
        
    } else if (type[1] == "modal") {
        DT::dataTableOutput(ns("level0"))
        stop("modal not implemented")
    } else {
        stop(paste("Type",type[1],"is not supported"))
    }
    
    # initialize data for each level
    # top level: level 0
    output$level0 <- renderDataTable(
        datatable(
            fgap_df(
                df = longdf,
                group_col = level_cols[1],
                value_col = value_col,
                agg_fn = agg_fn,
                pivot_col = pivot_col,
                pivot_fill = pivot_fill,
                transpose = transpose
            )
        )
    )
    
}