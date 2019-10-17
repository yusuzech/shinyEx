#' inserts JavaScript to detect if user is using Mobile Device
#' 
#' @details 
#' use \code{input$isMobile} to receive if user is using Mobile Device. the value
#' is either \code{TRUE} or \code{FALSE}.
#' 
#' @examples
#' if (interactive()){
#' shinyApp(
#'     ui <- fluidPage(
#'         isMobile()
#'     ),
#'     server <- function(input, output, session){
#'         isMobile <- eventReactive(input$isMobile,input$isMobile)
#'         observe(print(res()))
#'     }   
#'     )
#' }
#' @export
isMobile <- function(){
    shiny::tagList(
        shiny::singleton(
            # detect is user are using following devices
            tags$script("
            $(document).on('shiny:sessioninitialized', function(e){
                var isMobile = /((iPhone)|(iPad)|(Android)|(BlackBerry))/.test(navigator.userAgent);
                Shiny.setInputValue('isMobile',isMobile)
            })
                        ")
        )
    )
}