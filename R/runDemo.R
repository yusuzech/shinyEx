#' Run Demos
#' @export
runDemo <- function(name){
    path <- system.file(paste0("demos/",name),package = "shinyModulesEx")
    shiny::runApp(appDir = path)
}


#' Run Demo PairedDTplot
#' @export
runDemoPairedDTplotlyModule <- function(){
    runDemo("PairedDTplotlyModule")
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

#' run Demo FSDTModule
#' @export
runDemoFSDTModule <- function(){
    runDemo("FSDTModule")
}