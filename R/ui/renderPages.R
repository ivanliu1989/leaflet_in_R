
sideBarContent = function(mapData = NULL){
    res = sidebarMenu(
        id = "tabs",
        if(!is.null(mapData)){
            shinyjs::removeClass(id = "loading-initial", class = "busy")    
        },
        menuItem("Open Maps", tabName = "heatmapTab", icon = icon("file-text-o"),selected = TRUE)
    )
    return(res)
}


# tab layout
renderTabLayout = function(){
    
    res = tabItems(
        tabItem(tabName = "heatmapTab",
                uiOutput("heatmapUI")
        )
    )
    return(res)
}





