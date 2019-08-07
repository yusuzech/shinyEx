#' Run Demos
#' @export
runDemo <- function(name){
    system.file(paste0("demos/",name,"/app.R"),package = "shinyModulesEx")
    shiny::runApp(paste0("inst/demos/",name,"/app.R"))
}

