#' Generates arrow buttons
#' @export
arrowButtonGroupInput <- function(inputId,
                                  type = "h",
                                  origin = c(0L,0L)){
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
                <span style='opacity:0;'>&#11035</span>
                <span direction='right' value='+1,0' class='arrow-button'>&#9654</span>
            </div>
            <div>
                <span style='opacity:0'>&#9664</span>
                <span direction='down' value='0,-1' class='arrow-button'>&#9660</span>
                <span style='opacity:0'>&#9654</span>
            </div>"
    )
    if(!is.integer(origin)){
        stop("Origin should only be integers")
    }
    if(length(origin) == 1){
        origin = paste0(as.character(origin),",0")
    } else if(length(origin) == 2){
        origin = paste0(origin,collapse = ",")
    } else{
        stop("Length of origin should only be 1 or 2. e.g(1L, 2L, C(0L,0L), C(1L,5L) ...")
    }
    
    
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
            origin = origin,
            shiny::HTML(button_groups[[type]])
        )
    )
}
