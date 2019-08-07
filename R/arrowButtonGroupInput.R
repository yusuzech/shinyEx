#' Generates arrow buttons
#' @export
arrowButtonGroupInput <- function(inputId,
                                  start = 0L,
                                  type = "h",
                                  size = "100%",
                                  color="rgb(0,0,0)",
                                  colorClick="rgb(128,128,128)"){
    # validate user input
    if(!(type %in% c("v","h","a"))){
        stop("type can only be one of 'v'(vertical buttons),'h'(horizontal buttons) or 'a'(all buttons in four direction)")
    } else if (!(length(start) %in% c(1,2)) & is.integer(start)){
        stop("start must be integer vector with one or two elements.")
    } else if (type == "a" & length(start) == 1){
        stop("for type a(all buttons in four direction), must provide start such as c(0L,0L), c(0L,01L) ...")
    } else if(type %in% c("v","h") & length(start) == 2){
        stop("for type v(horizontal buttons) & v(vertical buttons), must provide start such 0L,1L...")
    }
    
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
                tags$style(id ="arrowButtonGroupInputCSS",css_text_glued)
            )
        ),
        tags$div(
            id = inputId,
            shiny::HTML(button_groups[[type]])
        )
    )
}
