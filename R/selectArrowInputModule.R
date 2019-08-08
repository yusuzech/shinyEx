#' UI placeholder for selectArrowInputModule
#' 
#' @param inputId inputId
#' 
#' @return UI component
#' 
#' @export
selectArrowInputModuleUI <- function(inputId){
    ns <- NS(inputId)
    shiny::uiOutput(ns("ui"))
}


#' Server for selectArrowInputModule
#' 
#' @param input input
#' @param output output
#' @param session session
#' @param InputId, label, ..., size are all arguments for selectInput
#' 
#' @return Renders UI and returns selected value as a reactive value
#' 
#' @export
selectArrowInputModule <- function(input,output,session,
                                   inputId, label, choices, selected = NULL,
                                   selectize = TRUE, width = NULL, size = NULL){
    ns <- session$ns
    output$ui <- renderUI({
        tagList(
            tags$div(
                style="display:inline-block",
                shiny::selectInput(ns("select"), label, choices, selected, multiple = FALSE,
                                   selectize, width, size)
            ),
            tags$div(
                style = "position:relative; top:-5px; display:inline-block",
                shinyModulesEx::arrowButtonGroupInput(ns("arrow"),type = "v")
            )
        )
    })
    
    
    observeEvent(input$arrow,{
        req(!is.null(input$arrow))
        direction <- strsplit(input$arrow,":",)[[1]][1]
        val_position <- which(input$select == choices)

        if(direction == "up"){
            val_position <- val_position - 1
        } else if(direction == "down"){
            val_position <- val_position + 1
        }
        
        updateSelectInput(
            session = session,
            inputId = "select",
            selected = choices[val_position]
        )
    })
    return(reactive({input$select}))
}
