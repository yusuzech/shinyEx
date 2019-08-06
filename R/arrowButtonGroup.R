arrowButtonGroupUI <- function(id){
    ns <- NS(id)
    useShinyjs()
    uiOutput(ns("arrowButtonsUI"))
}

arrowButtonGroup <- function(input,output,session,
                             size = "150%",
                             color = "green",
                             colorHover = "blue",
                             buttons = "all"){
    module_id <- session$ns("arrowButtonsUI")
    
    group_horizontal <- glue("    
    <div style='line-height:100%;color:{color}'> 
        <span button-direction='left'>&#9664</span>
        <span button-direction='center' style='font-size:130%'>&#9724</span>
        <span button-direction='right'>&#9654</span>
    </div>")
    group_vertical <- glue("    
    <div style='line-height:100%;color:{color}'>
        <div>
            <span button-direction='up'>&#9650</span>
        </div>
        <div>
            <span button-direction='center' style='font-size:130%'>&#9724</span>
        </div>
        <div>
            <span button-direction='down'>&#9660</span>
        </div>
    </div>")
    group_all <- glue("    
    <div style='line-height:100%;color:{color}'>
            <div>
                <span style='opacity:0'>&#9664</span>
                <span button-direction='up'> &#9650</span>
                <span style='opacity:0'>&#9654</span>
            </div>
            <div>
                <span button-direction='left'>&#9664</span>
                <span button-direction='button-center' style='font-size:130%'>&#9724</span>
                <span button-direction='right'>&#9654</span>
            </div>
            <div>
                <span style='opacity:0'>&#9664</span>
                <span button-direction='down'> &#9660</span>
                <span style='opacity:0'>&#9654</span>
            </div>
    </div>")
    output$arrowButtonsUI <- renderUI({
        shiny::HTML(group_vertical)
    })
    
}