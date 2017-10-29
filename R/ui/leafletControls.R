mapSelectState = function(dat){
    options = names(dat$visits)
    displayName = fread('data/stateMapping.csv')
    setkey(displayName, Short)
    names(options) = displayName[options, Long]
    
    return(options)
}


mapFilteredDT = function(d, config){
    dat = d$visits[[config$MapState]]
    
    return(list(dat = dat,
                loc.info = d$loc.info,
                post.info = d$post.info))
}

mapDataCleaning = function(d){
    
    library(splitstackshape)
    
    d$dat[, postcode := as.numeric(postcode)]
    d$post.info[, postcode := as.numeric(postcode)]
    dat = merge(d$dat, unique(d$post.info[, .(postcode, lat, lon)]), by = 'postcode')
    dat = dat[!is.null(dat$lon)]
    
    dat.scale = copy(dat)
    dat.scale[, visits:=round(visits/1000)]
    dat.scale[, visits:=ifelse(visits==0, 1, visits)]
    dat.expand = expandRows(dat.scale, 'visits')
    dat.expand = merge(dat.expand, dat[, .(postcode, visits)], by = 'postcode', x.all =TRUE)
    post.points = unique(d$post.info[postcode %in% dat$postcode])
    
    res = list(dat = dat,
               dat.expand = dat.expand,
               post.points = post.points,
               post.info = d$post.info,
               loc.info = d$loc.info
               )
    
    return(res)
}


cleanPostSurburDT = function(dat, id, SelectState){
    if(SelectState == 'NAT'){
        states = mapSelectState(loadDat())
        displayState = displayState = ifelse(length(states[names(states) == id]) == 0, 'NSW', states[names(states) == id])
        surburb = merge(dat$dat, dat$post.info[state == displayState])
    }else{
        surburb = merge(dat$post.info, dat$dat, by = 'postcode')
    }
    surburb = surburb[, .(postcode, area, state, visits, lat.x, lon.x)]
    names(surburb) = c('Postcode', 'Surburb', 'State', 'Visits', 'Latitude', 'Longitude')
    return(surburb)
}

topPostPanelPlot = function(dat, id, SelectState){
    if(SelectState == 'NAT'){
        states = mapSelectState(loadDat())
        displayState = ifelse(length(states[names(states) == id]) == 0, 'NSW', states[names(states) == id])
        plotDat = merge(dat$dat, dat$post.info[state == displayState])
        plotDat = unique(plotDat[, .(postcode, visits)])
        setorder(plotDat, -visits)
        plotDat = plotDat[1:10, ]
        plotDat$postcode = factor(plotDat$postcode)
        
    }else{
        plotDat = copy(dat$dat)
        setorder(plotDat, -visits)
        plotDat = plotDat[1:10, ]
        plotDat$postcode = factor(plotDat$postcode)
    }
    g <- ggplot(plotDat, aes(x = postcode, y = visits)) +
        geom_bar(stat = "identity", fill=quantColours(1)) +
        scale_y_continuous() + 
        guides(fill=FALSE) + 
        labs(title = paste0('Top 10 Postcodes - ', id), x = 'Postcode', y = 'Visits') +
        theme_anzquant(simple_theme = TRUE, anz_font = F, anz_colours = TRUE)
    
    return(g)
}