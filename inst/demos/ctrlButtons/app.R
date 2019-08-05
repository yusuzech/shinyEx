library(shiny)

ui <- fluidPage(
    # CSS for buttons
    inlineCSS(
        "
    .bsquare {
    height: 50px;
    width: 50px;
    background-color: #555;
    }
    
    .btriangle-up {
    	width: 0;
    	height: 0;
    	border-left: 25px solid transparent;
    	border-right: 25px solid transparent;
    	border-bottom: 50px solid #555;
    }
    
    .btriangle-down {
    	width: 0;
    	height: 0;
    	border-left: 25px solid transparent;
    	border-right: 25px solid transparent;
    	border-top: 50px solid #555;
    }
    
    .btriangle-left {
    	width: 0;
    	height: 0;
    	border-top: 25px solid transparent;
    	border-right: 50px solid #555;
    	border-bottom: 25px solid transparent;
    }
    
    .btriangle-right {
    	width: 0;
    	height: 0;
    	border-top: 25px solid transparent;
    	border-left: 50px solid #555;
    	border-bottom: 25px solid transparent;
    }
        "
    ),
    shiny::HTML(
        "
    <div style='display:inline'>
        <div class='btriangle-left'></div> 
        <div class='btriangle-right'></div>
    </div>
        "
    )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)