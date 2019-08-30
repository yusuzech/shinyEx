# provide df 
# provide id columns vec with length at least 1
# provide row css data frame
# provide row format type vector
# number format dict 
# list(
#   currency = list(keyword = c("money","currency"),digits = 0,symbol = "$"),
#   percent = list(keyword = c("percent","percentage"),digits = 2),
#   comma = list(keyword = c("number","general"),digits = 1),
#   accounting = list(keyword = c("accounting"),digits = 0)
#)
#
#
#
# 0 threshhold logical
# nrow(df) == nrow(css data frame) ==  length(row_type)


#' return a list that contains all sample data required to make a FSDT
#' 
#' @description 
#' FSDT is the abbreviation of Financial Statement Data Table.
#' 
#' @return a list which contains all data required to make a FSDT
#' 
#' @seealso \code{\link{createFSTable}}
#' 
#' @export
FSDTSampleData <- function(){
    df <- tibble(
        items = letters[1:10],
        additional_item = LETTERS[1:10],
        `2019-Total` = runif(10,-1,1),
        `2019-YTD` = runif(10,-1,1),
        `2019-1` = runif(10,-1,1),
        `2019-2` = runif(10,-1,1),
        `2019-3` = runif(10,-1,1),
        `2019-4` = runif(10,-1,1)
    )
    
    number_format_rule <- list(
        currency = list(keyword = c("money","currency"),digits = 0,symbol = "$"),
        percent = list(keyword = c("percent","percentage"),digits = 2),
        comma = list(keyword = c("number","general"),digits = 1),
        accounting = list(keyword = c("accounting"),digits = 0)
    )
    
    row_type <- c("currency","currency","money","percent","percentage",
                  "number","general","general","accounting","accounting")
    
    row_css <- tibble::tibble(`font-size` = rep(c("100%","80%"),5),
                         weight = rep(c("normal","bold"),5),
                         `text-decoration` = rep(c("none","underline"),5))
    
    color_negative <- TRUE
    
    return(
        list(
            df = df,
            id = c("items","additional_item"),
            row_type = row_type,
            row_css = row_css,
            color_negative = color_negative,
            number_format_rule = number_format_rule
        )
    )
}


#' Convert cells in a data frame to HTML text
#' 
#' @description 
#' This function is useful for creating visually pleasing Financial Statement 
#' using the DT Package. Features of this function:
#' 
#' 1. numbers are formatted by row by providing row_type vector. supported formats
#' are currecny, percent, comma and accounting. This feature makes use of formattable
#' package.
#' 
#' 2. negative numbers can be colored coded to red if color_negative is \code{TRUE}
#' 
#' 3. supports all css of div tag by surrounding text with 
#' \code{<div class="...">your-text</div>}. 
#' 
#' @param df a data frame
#' @param id id columns for the data frame. Columns other than id columns must be
#' numeric
#' @param row_type a character vector, its length must equal to number of rows in
#' df. Types for each row,valid choices are "currency","percent", "comma" and 
#' "accounting". To add more valid choices, 
#' modify \code{row_format_rule}
#' @param row_format_rule when set to \code{default}, will use default rules. To
#' customize it, see details section.
#' @param row_css a data frame, it must have the same number of rows as df. column
#' names should be valid css attributes. columns must contain valid values for 
#' corresponding attributes.
#' @param color_negative default to \code{TRUE}, whether to color numbers smaller
#' than 0 to red
#' 
#' @return a data frame, cells contains HTML text, which can be parsed by 
#' \code{\link{DT::datatable}}
#' 
#' @details 
#' 1.row_format_rule:
#' 
#' When \code{row_format_rule} is \code{default}, it will use the rules in
#' \code{link{FSDTSampleData}}.
#' 
#' Now this function supports four formats, which are "currency","percent","comma" 
#' and "accounting", it uses functions in formattable package. To customize rules, 
#' you must provide a list with the four type names as key. For each key value pair,
#' the value must also be a list with keyword, digits as key. When setting up "currency",
#' you can also use "symbol" as key.
#' 
#' A valid rule should look like \code{list(
#'    currency = list(keywords = c("Dollar","amount","currency"), digits = 2, symbol = "$"),
#'    percent = list(keyword = c("percent","percentage"),digits = 2),
#'    ... etc
#' )}
#' 
#' @seealso \code{\link{FSDTSampleData}}
#' 
#' @export
createFSTable <- function(df,id,row_type,
                       row_format_rule = "default",
                       row_css,
                       color_negative = TRUE){
    value <- base::setdiff(colnames(df),id)
    df_column_types <- purrr::map_lgl(df[,value],is.numeric)
    
    # valid that all mappings have the same length
    if (nrow(df) != nrow(row_css)){
        stop("Number of rows in df and row_css are not equal")
    }
    
    if (nrow(df) != length(row_type)) {
        stop("Number of rows in df and length of row_type are not equal")
    }
    
    # valid all value columns are numeric
    if(!all(df_column_types)){
        msg <- paste(
            "Column",
            paste0(df_column_types[which(!df_column_types)],collapse = ", "),
            "not numeric"
        )
    }
    df_id <- df[,id]
    df_value <- df[,value]
    
    # get row_format_rule
    if(is.character(row_format_rule)){
        if (row_format_rule == "default") {
            row_format_rule <- list(
                currency = list(keyword = c("money","currency"),digits = 0,symbol = "$"),
                percent = list(keyword = c("percent","percentage"),digits = 2),
                comma = list(keyword = c("number","general"),digits = 1),
                accounting = list(keyword = c("accounting"),digits = 0)
            )
        }
    } else if ( is.list(row_format_rule)) {
        #pass
    } else {
        stop("row_format_rule must be 'default' or a list.")
    }
    
    # check if user provided row_type are all valid
    provided_types <- reduce(map(row_format_rule,"keyword"),c)
    if(!all(row_type %in% provided_types)){
        msg <- paste(
            paste0(row_type[which(!(row_type %in% provided_types))],collapse = ", "),
            "not valid type"
        )
    }
    
    # convert prrovided type in keyword to accurate type used by formattable
    number_keywords <- map(row_format_rule,"keyword")
    valid_row_type <- map_chr(row_type, function(x){
        type_lgl <- map_lgl(number_keywords,function(y){any(y == x)})
        names(type_lgl[type_lgl])
    })
    
    # format numbers according to its type, convert numbers to string
    df_value_foramtted <- purrr::reduce(
        purrr::pmap(
            bind_cols(tibble::tibble(type =valid_row_type),df_value),
            function(type,...){
                value = unlist(list(...))
                format_number(
                    value,type,
                    digits = row_format_rule[[type]][["digits"]],
                    symbol = row_format_rule[[type]][["symbol"]]
                )
            }
        ),
        bind_rows
    )
    
    # give all values div tag and specify colors inside style attribute row-wisely
    df_0_flag <- purrr::map_dfc(df_value,function(d){
        ifelse(
            d < 0,
            "red",
            "black"
        )
    })
    
    df_value_out <- purrr::map2_dfc(df_value_foramtted,df_0_flag,function(x,y){
        as.character(glue::glue('<div style="color:{y};">{x}</div>'))
    })
    
    df_id_html <- purrr::map_dfc(df_id,function(x){
        as.character(glue::glue('<div style="">{x}</div>'))
    })
    
    df_full <- dplyr::bind_cols(df_id_html,df_value_out)
    
    # apply other attributes row-wisely
    for(i in 1:ncol(row_css)){
        attribute_name <- colnames(row_css)[i]
        attribute_values <- row_css[,i]
        df_full <- purrr::map2_dfr(df_full,attribute_values,function(row,x){
            stringr::str_replace(
                string = row,
                pattern = '\\">',
                replacement = paste0(" ",attribute_name,":",x,';">') 
            )
        })
    }
    
    return(df_full)
    
}

#' UI of FSDTModule
#' 
#' @param id id for the module
#' 
#' @seealso \code{\link{FSDTModule}}
#' 
#' @export

FSDTModuleUI <- function(id){
    ns <- NS(id)
    
    DT::dataTableOutput(ns("FSDT"))
    
}


#' Server of FSDT Module
#' 
#' @param input shiny input
#' @param output shiny outpu
#' @param session shiny session
#' @param df a data frame, preferably generated with \link{createFSTable}
#' @param extensions a character vector, default to 
#' \code{c("FixedHeader",'FixedColumns')}. value is passed to \link{DT::datatable}
#' @param dt_options "default" or a list. value is passed to \code{options} 
#' argument in \link{DT::datatable}
#' 
#' @return generates a datatable in DT package with predefined or custom attributes
#' 
#' @seealso \link{createFSTable}, \link{FSDTModuleUI}
#' 
#' @export
FSDTModule <- function(input, output, session, df,
                       extensions = c("FixedHeader",'FixedColumns'),
                       dt_options = "default"){
    # validate user input
    stopifnot(is.data.frame(df))
    if(is.character(dt_options)){
        if(dt_options == "default"){
            dt_options <- list(
                scrollX = TRUE,
                scrollY = "500px",
                dom="Btip",
                pageLength =500,
                rownames= FALSE,
                fixedColumns = list(leftColumns = 2),
                ordering = FALSE
            )
        }
    } else if (is.list(dt_options)){
        # pass value directly
    } else {
        stop(paste("dt_options should either be 'default' or a list"))
    }
    
    
    output$FSDT <- DT::renderDataTable(
        DT::datatable(
            df,
            extensions = extensions,
            options = dt_options,
            escape = FALSE
        )
    )
}
