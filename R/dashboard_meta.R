#' run this function to quickly initialize a shiny app folder
#'  @description 
#'  By running this function, it will create following files in given path:
#'  1. app.R if mode is "single"; ui.R, server.R, global.R if mode is "multiple"
#'  2. Folders: www/, www/css, www/js, www/img
#'  
#'  Behavior: this function won't overwrite existing files
#'  
#'  @param path path to folder
#'  @param mode what files to create, see more in description
#'  @param overwrite whether to overwrite existing files
#'  
#'  @return NULL, creates folders and files instead
#'  @export
shinyInit <- function(path,mode = c("single","multiple")){
    cat(paste(
        "By running this function, it will create files and folder in given file",
        "Proceed?"
    ))
    
    user_input <- menu(c("Yes","No","I'm not sure"))
    if (user_input != 1) return("Initialization cancelled.")
    
    if(!(substr(path,nchar(path),nchar(path)) %in% c("/","\\"))) path <- paste0(path,"/")
    
    # create folders
    if (!dir.exists(path)) {
        dir.create(path)
        cat(paste("Created folder:",path,"\n"))
    }
    
    folders <- paste0(path,c("www/","www/css/","www/js/","www/img/"))
    for(folder in folders){
        if(dir.exists(folder)) next
        dir.create(folder)
        cat(paste("Created folder:",folder,"\n"))
    }
    
    # create files
    files <- switch(mode[1],
        "single" = c("app.R"),
        "multiple" = c("ui.R","server.R","global.R")
    )
    
    for(f in files){
        status <- file.create(paste0(path,f))
        if(!status) warning(paste("Failed to Create:", paste0(path,f)))
        cat("Created file:", paste0(path,f),"\n")
    }
}