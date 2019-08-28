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


id <- c("items","additional_item")
value <- setdiff(colnames(df),id)

df_column_types <- purrr::map_lgl(df[,value],is.numeric)
if(!all(df_column_types)){
    msg <- paste(
        "Column",
        paste0(df_column_types[which(!df_column_types)],collapse = ", "),
        "not numeric"
    )
}
df_value <- df[value]

# format numbers 
number_format_rule <- list(
  currency = list(keyword = c("money","currency"),digits = 0,symbol = "$"),
  percent = list(keyword = c("percent","percentage"),digits = 2),
  comma = list(keyword = c("number","general"),digits = 1),
  accounting = list(keyword = c("accounting"),digits = 0)
)
provided_types <- reduce(map(number_format_rule,"keyword"),c)


#user provided vec
row_type <- c("currency","currency","money","percent","percentage","number","general","general","accounting","accounting")

if(!all(row_type %in% provided_types)){
    msg <- paste(
        paste0(row_type[which(!(row_type %in% provided_types))],collapse = ", "),
        "not valid type"
    )
}

number_keywords <- map(number_format_rule,"keyword")
valid_row_type <- map_chr(row_type, function(x){
    type_lgl <- map_lgl(number_keywords,function(y){any(y == x)})
    names(type_lgl[type_lgl])
})

format_number <- function(x,type){
    if (type == "currency") {
        out <- formattable::currency(
            x, digits = number_format_rule[[type]][["digits"]],
            symbol = number_format_rule[[type]][["symbol"]]
        )
    } else if (type == "percent") {
        out <- formattable::percent(
            x, digits = number_format_rule[[type]][["digits"]]
        )
    } else if (type == "comma") {
        out <- formattable::comma(
            x, digits = number_format_rule[[type]][["digits"]]
        )
    } else if (type == "accounting") {
        out <- formattable::accounting(
            x, digits = number_format_rule[[type]][["digits"]]
        )
    }
    return(as.character(out))
}

df_value_foramtted <- purrr::reduce(
    purrr::pmap(
        bind_cols(tibble::tibble(type =valid_row_type),df_value),
        function(type,...){
            value = unlist(list(...))
            format_number(value,type)
        }
    ),
    bind_rows
)

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

# other styles
test_style <- tibble(`font-size` = rep(c("100%","80%"),5))

map2_dfr(df_value_out,test_style,function(row,x){
    stringr::str_replace(
        string = row,
        pattern = '\\">',
        replacement = paste0(" font-size:",x,';">') 
    )
}) %>%
    datatable(escape = FALSE)


FSDTExample <- function(){
    
}


FSDT


FSDTModule