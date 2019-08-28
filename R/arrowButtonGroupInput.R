#' Generates arrow buttons
#' @export
arrowButtonGroupInput <- function(inputId,
                                  type = "h"){
    shiny::addResourcePath(
        prefix = "www",
        directoryPath = system.file("www/arrowButtonGroupInput",package = "shinyModulesEx")
    )
    
    button_groups <- list(
        h = "<span direction='left' value='-1,0' class='arrow-button'>&#9664</span>
             <span direction='right' value='+1,0' class='arrow-button'>&#9654</span>",
        v = "    
                <div>
                    <span direction='up' value='0,+1' class='arrow-button'>&#9650</span>
                </div>
                <div>
                    <span direction='down' value='0,-1' class='arrow-button'>&#9660</span>
                </div>",
        a = "
            <div>
                <span style='opacity:0'>&#9664</span>
                <span direction='up' value='0,+1' class='arrow-button'>&#9650</span>
                <span style='opacity:0'>&#9654</span>
            </div>
            <div>
                <span direction='left' value='-1,0' class='arrow-button'>&#9664</span>
                <span style='opacity:0;'>&#9664</span>
                <span direction='right' value='+1,0' class='arrow-button'>&#9654</span>
            </div>
            <div>
                <span style='opacity:0'>&#9664</span>
                <span direction='down' value='0,-1' class='arrow-button'>&#9660</span>
                <span style='opacity:0'>&#9654</span>
            </div>"
    )
    
    
    # return taglist
    tagList(
        singleton(
            tags$head(
                # production
                tags$link(rel = 'stylesheet',href="/www/arrowButtonGroupInput.css"),
                tags$script(src = "/www/arrowButtonGroupInput.js")
            )
        ),
        tags$div(
            id = inputId,
            style='line-height:110%',
            class='arrow-button-group',
            type = type,
            shiny::HTML(button_groups[[type]])
        )
    )
}
