#' Run Demos
#' @export
runDemo <- function(name){
    path <- system.file(paste0("demos/",name),package = "shinyModulesEx")
    shiny::runApp(appDir = path)
}


#' Run Demo PairedDTplot
#' @export
runDemoPairedDTplot <- function(){
    runDemo("PairedDTplot")
}


#' run Demo arrowButtonGroupInput
#' @export
runDemoarrowButtonGroupInput <- function(){
    runDemo("arrowButtonGroupInput")
}

#' run Demo selectArrowInputModule
#' @export
runDemoselectArrowInputModule <- function(){
    runDemo("selectArrowInputModule")
}