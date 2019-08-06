library(shiny)
library(glue)
library(shinyjs)

mymoduleUI <- function(id){
    ns <- NS(id)
    uiOutput(ns("text"))
}

mymodule <- function(input,output,session,color,colorHover){
    id <- session$ns("mymoduleUI")
    css_text <- glue("#{id} p{{color:{color};}}
                    #{id} p:hover{{color:{colorHover};}}")
    print(css_text)
    output$text <- renderUI({
        shinyjs::inlineCSS(rules = css_text)
        tags$p("text inside module")
    })
    shinyjs::runjs(text)
}


shinyApp(
    ui = basicPage(
        tags$head(tags$style("p{color:balck;}
                             p:hover{color:grey}")),
        tags$p("text outside module"),
        mymoduleUI("here")
    ),
    server = function(input, output) {
        callModule(module = mymodule,id = 'here',color="blue",colorHover="red")
    }
)


