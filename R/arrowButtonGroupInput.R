#' Generates arrow buttons
#' @export
arrowButtonGroupInput <- function(inputId,
                                  type = "h",
                                  size = "100%",
                                  color="rgb(0,0,0)",
                                  colorClick="rgb(128,128,128)"){
    print("development version")
    
    css_text <- readwwwResource("css/arrowButtonGroupInput.css") # CSS templates
    # read size,color and colorClick
    css_text_glued <- glueCSS(css_text)
    
    button_groups <- list(
        h ="    
            <div style='line-height:110%' class='arrow-button-group'> 
                <span button-direction='left' class='arrow-button'>&#9664</span>
                <span button-direction='right' class='arrow-button'>&#9654</span>
            </div>",
        v ="    
            <div style='line-height:110%' class='arrow-button-group'>
                <div>
                    <span button-direction='up' class='arrow-button'>&#9650</span>
                </div>
                <div>
                    <span button-direction='down' class='arrow-button'>&#9660</span>
                </div>
            </div>",
        a ="    
        <div style='line-height:110%' class='arrow-button-group'>
            <div>
                <span style='opacity:0'>&#9664</span>
                <span button-direction='up' class='arrow-button'>&#9650</span>
                <span style='opacity:0'>&#9654</span>
            </div>
            <div>
                <span button-direction='left' class='arrow-button'>&#9664</span>
                <span style='opacity:0;'>&#11035</span>
                <span button-direction='right' class='arrow-button'>&#9654</span>
            </div>
            <div>
                <span style='opacity:0'>&#9664</span>
                <span button-direction='down' class='arrow-button'>&#9660</span>
                <span style='opacity:0'>&#9654</span>
            </div>
    </div>"
    )
    
    if(type %in% c("v","h")){
        
    } else {
        
    }
    
    
    # return taglist
    tagList(
        singleton(
            tags$head(
                # production
                tags$style(id ="arrowButtonGroupInputCSS",css_text_glued),
                # tags$script(src = wwwResourcePath("js/arrowButtonGroupInput.R"))
                #development
                tags$script(src = "js/arrowButtonGroupInput.R")
            )
        ),
        tags$div(
            id = inputId,
            shiny::HTML(button_groups[[type]])
        )
    )
}
