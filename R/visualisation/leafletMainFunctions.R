generateLeaflet <- function(dat, config, basinDF){
    
    circles <- unique(dat$post.points[, .(postcode, lat, lon)])
    states = mapSelectState(loadDat())
    
    if(config$SelectState != 'NAT'){
        displayState = names(states)[states == config$SelectState]
    }else{
        displayState = names(states)[!states %in% 'NSW']
    }
    nswColor = ifelse(config$ReportType == 'topDest', anzcolour()[1], anzcolour()[3])
    pal = colorNumeric("Reds",domain = NULL)
    
    # d = dat$dat.expand[,.SD[sample(.N,max(1,.N*0.05))],by = postcode]
    
    # if(config$MapType == 'heat'){
        m = leaflet(dat$dat.expand) %>% 
            addWebGLHeatmap(lng=~lon, lat=~lat, size = config$RadiusSize * 10000,
                            opacity = 0.7, alphaRange = 1, layerId = 'GLHeatMap') %>%
            addProviderTiles(config$MapProvider) %>%
            addPolygons(data=subset(basinDF, STATE_NAME %in% displayState), weight=0.3,
                        color = anzcolour()[1], opacity = 1, fillOpacity = 0.4, layerId = ~STATE_NAME) %>%
            addPolygons(data=subset(basinDF, STATE_NAME %in% 'New South Wales'), weight=0.3,
                        color = nswColor, opacity = 1, fillOpacity = 0.4, layerId = ~STATE_NAME) %>%
            addCircleMarkers(data = dat$dat.expand, lng=~lon, lat=~lat,
                             opacity = 0.6, color = ~pal(log(visits)), #anzcolour()[7], #
                             fill = TRUE,
                             fillOpacity = 0.6,
                             radius = ~log(visits) * 0.8,
                             clusterOptions = markerClusterOptions(),
                             layerId = ~paste(postcode)
            ) %>%
            addLegend(position = "bottomleft", colors=c(anzcolour()[3], anzcolour()[1], anzcolour()[7]),
                      labels=c('Origins', 'Destinations', "Visits ('000)"), opacity = 0.9, title = 'Legend',
                      layerId="colorLegend") 
    # }else{
    # 
    #     radiusSize = round(config$RadiusSize / 2)
    # 
    #     kde <- bkde2D(dat$dat.expand[ , list(lon, lat)],
    #                   bandwidth=c(radiusSize * 0.15, radiusSize * 0.18), gridsize = c(radiusSize * 150,radiusSize * 150))
    #     CL <- contourLines(kde$x1 , kde$x2 , kde$fhat)
    #     LEVS <- as.factor(sapply(CL, `[[`, "level"))
    #     NLEV <- length(levels(LEVS))
    #     pgons <- lapply(1:length(CL), function(i)
    #         Polygons(list(Polygon(cbind(CL[[i]]$x, CL[[i]]$y))), ID=i))
    #     spgons = SpatialPolygons(pgons)
    # 
    # 
    #     m = leaflet(spgons) %>%
    #         addProviderTiles(config$MapProvider) %>%
    # 
    #         addPolygons(data=subset(basinDF, STATE_NAME %in% displayState), weight=0,
    #                     color = anzcolour()[1], opacity = 1, fillOpacity = 0.8, layerId = ~STATE_NAME) %>%
    #         addPolygons(data=subset(basinDF, STATE_NAME %in% 'New South Wales'), weight=0,
    #                     color = nswColor, opacity = 1, fillOpacity = 0.8, layerId = ~STATE_NAME) %>%
    #         addPolygons(stroke = FALSE, color = heat.colors(NLEV, NULL)[LEVS],
    #                     weight = radiusSize * 0.02,
    #                     opacity = 0.35, fillOpacity = 0.35) %>%
    #         addCircleMarkers(data = dat$dat, lng=~lon, lat=~lat,
    #                          opacity = 0.6, color = ~pal(log(visits)), #anzcolour()[7],
    #                          fill = TRUE,
    #                          fillOpacity = 0.6,
    #                          radius = ~log(visits) * 0.5,
    #                          clusterOptions = markerClusterOptions(),
    #                          layerId = ~paste(postcode)
    #         ) %>%
    #         addLegend(position = "bottomleft", colors=c(anzcolour()[3], anzcolour()[1], anzcolour()[7]),
    #                   labels=c('Origins', 'Destinations', 'Postcode'), opacity = 0.9, title = 'Legend',
    #                   layerId="colorLegend")
    # }
    
    return(m)
}


