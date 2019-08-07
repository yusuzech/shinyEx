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
