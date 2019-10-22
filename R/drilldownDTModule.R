#' UI for drillDTModalModule
#' export
drillDTModalModuleUI <- function(id){
    ns <- NS(id)
    DT::dataTableOutput(ns("level0"))
}



drillDTModalModule <- function(input,output,session,
                             longdf,
                             levels_col,
                             value_col,
                             agg_fn = sum,
                             pivot_col = NULL,
                             transpose = FALSE,
                             fill_level = FALSE,
                             fill_value = NA
) {
    value_col_sym <- sym(value_col)
    if (fill_level) {
        full_df <- do.call(tidyr::expand_grid,Map(unique,longdf[,c(levels_col,pivot_col)]))
        longdf <- longdf %>%
            dplyr::right_join(full_df,by = c(levels_col,pivot_col)) %>%
            dplyr::mutate(
                !!value_col_sym := ifelse(is.na(!!value_col_sym),fill_value,!!value_col_sym)
            )
    }
    # initialize data for each level, not needed for first and last level
    levels_data <- reactiveValues(current_level = 1)
    for(i in (2:length(levels_col)-1)){
        levels_data[[paste0("level",i)]] <- NULL
    }
    
    # function to prepare DT in each level:
    prepareDT <- function(df,level,){
        df %>%
            group_by_at(c(level,pivot_col))
    }
    # first level DT
    
}