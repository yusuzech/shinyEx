#' get resource file path
#' @export

wwwResourcePath <- function(path){
    system_path <- system.file("www",package = "shinyModulesEx", mustWork = TRUE)
    file_path <- paste0(system_path,"/",path)
    if(!file.exists(file_path)){
        stop(paste0(file_path," does not exist"))
    }
    return(file_path)
}

#' read resource file into text
#' @export
readwwwResource <- function(path){
    file_path <- wwwResourcePath(path)
    return(paste0(readLines(file_path),collapse = "\n"))
}

#' use CSS templates with < & >
#' @export
glueCSS <- function(...,.envir = parent.frame()){
    glue::glue(...,.open = "{{", .close = "}}",.envir = .envir)
}


#' using formattable functions to format a vector given its type
#' 
#' @param x a numeric vector
#' @param type type for the vector, valid values are "currency", "percent", 
#' "comma" and "accounting"
#' @param digits digits for the number
#' @param symbol, currency symbol. only works when type is currency.
#' 
#' @return a character vector with formatted numbers
format_number <- function(x,type,digits = 0,symbol = "$"){
    if (type == "currency") {
        out <- formattable::currency(x, digits = digits,symbol = symbol)
    } else if (type == "percent") {
        out <- formattable::percent(x, digits = digits)
    } else if (type == "comma") {
        out <- formattable::comma(x, digits = digits)
    } else if (type == "accounting") {
        out <- formattable::accounting(x, digits = digits)
    }
    return(as.character(out))
}
