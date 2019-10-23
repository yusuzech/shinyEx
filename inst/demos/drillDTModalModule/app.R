library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)

set.seed(1234)
sampleData <-
    tidyr::expand_grid(
        level0 = c("A","B","C"),
        level1 = c("a","b","c","d"),
        level2 = c("x","y","z"),
        level3 = c("m","n","o"),
        group_col = c("group1","group2","group3","group4")
    ) %>%
    dplyr::mutate(
        value = runif(n = nrow(.)),
        drop = sample(letters,n(),replace = TRUE)
    ) %>%
    {
        .[sample(1:nrow(.),size = nrow(.) * 0.5),]
    }

ui <- fluidPage(
    drilldownDTModuleUI("test1")
)

server <- function(input, output, session) {
    callModule(
        module = drilldownDTModule,
        id = "test1",
        sampleData,
        level_cols = colnames(sampleData)[1:4],
        value_col = "value",
        options = list(
            box = list(
                title = "Test Title"
            )
        )
    )
}

shinyApp(ui, server)