anzcolour <- function(i = NULL, inv = 1){
    # x = c("#812990", "#001C86", "#0473B6", "#00833F", "#79C143", "#799A0D", "#FFCC31")
    if(inv==1){
        x = c("#004165", "#4984b3", "#007dba", "#49c7eb", "#b9e0f6", "#747678", "#df7a50", "#fdc82f", "#00833F") # "#5bc6e8",
    }else if(inv==2){
        x = c("#004165", "#49c7eb", "#fdc82f", "#4984b3", "#df7a50", "#00833F", "#007dba", "#b9e0f6", "#747678") # "#5bc6e8",
    }else{
        x = c("#004165", "#ff0000", "#49c7eb", "#fdc82f", "#df7a50", "#4984b3", "#00833F", "#007dba", "#b9e0f6", "#747678") #
    }
    
    # this is not very robust - what if 1 not in 1:6 or NA
    if(is.null(i)){
        return(x)
    }else{
        return(x[i])
    }
}

quantColours = function(i = NULL, inv = 1){
    # x = c("#812990", "#001C86", "#0473B6", "#00833F", "#79C143", "#799A0D", "#FFCC31")
    if(inv==1){
        x = c("#004165", "#4984b3", "#007dba", "#49c7eb", "#b9e0f6", "#747678", "#df7a50", "#fdc82f", "#00833F") # "#5bc6e8",
    }else if(inv==2){
        x = c("#004165", "#49c7eb", "#fdc82f", "#4984b3", "#df7a50", "#00833F", "#007dba", "#b9e0f6", "#747678") # "#5bc6e8",
    }else{
        x = c("#004165", "#ff0000", "#49c7eb", "#fdc82f", "#df7a50", "#4984b3", "#00833F", "#007dba", "#b9e0f6", "#747678") #
    }
    
    # this is not very robust - what if 1 not in 1:6 or NA
    if(is.null(i)){
        return(x)
    }else{
        return(x[i])
    }
}


theme_anzquant = function(simple_theme = TRUE,
         anz_font = TRUE,
         anz_colours = TRUE,
         font_size = 12L,
         logo = "none",
         opacity = 0.1,
         position = 0L,
         inv = FALSE){
    
    library(ggplot2)
    library(png)
    library(grid)
    library(gridExtra)
    
    if(!is.logical(simple_theme)) stop("argument 'simple_theme' must be logical")
    if(!is.logical(anz_font)) stop("argument 'anz_font' must be logical")
    if(!is.logical(anz_colours)) stop("argument 'anz_colours' must be logical")
    
    logo <- tolower(logo)
    if(!logo %in% c("anz","none") ) stop("logo must be 'anz' or 'none'.\nCase does not matter.")
    
    if(logo != "none"){
        # alpha = switch(opacity,
        #                "full" = "100",
        #                "half" = "50")
        # if(is.null(alpha)) stop("opacity argument must be either 'full' or 'half'")
        
        logo_path <- "/home/ivanliu/analytics/RQuant/image/ANZ.png"
        
        if (!file.exists(logo_path)) stop("File does not exist. Feel free to create your own logo and ask Ivan about implementing it.")
        
        img <- readPNG(logo_path)
        logo_object <- rasterGrob(img, interpolate=TRUE)
        w <- matrix(rgb(img[,,1],img[,,2],img[,,3],img[,,4] * opacity), nrow=dim(img)[1])
    }
    
    result_theme <- list( if(simple_theme) theme_minimal() else NULL,
                          if(logo != "none") annotation_custom(rasterGrob(w), xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf) else NULL,
                          if(anz_colours) scale_color_manual(values = quantColours(inv = inv)) else NULL,
                          if(anz_colours) scale_fill_manual(values = quantColours(inv = inv)) else NULL,
                          if(anz_font){
                              theme(text = element_text(family = 'carlito',
                                                        face = 'bold'))}else{NULL},
                          theme(text = element_text(size = font_size)))
    
    
    result_theme
    
}