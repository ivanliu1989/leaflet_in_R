## INITIALIZE
library("leaflet")
library("data.table")
library("sp")
library("rgdal")
# library("maptools")
library("KernSmooth")

infile <- "data/mvthefts.csv"

## LOAD DATA
## Also, clean up variable names, and convert dates
dat <- data.table::fread(infile)
setnames(dat, tolower(colnames(dat)))
setnames(dat, gsub(" ", "_", colnames(dat)))
dat <- dat[!is.na(longitude)]
dat[ , date := as.IDate(date, "%m/%d/%Y")]

## MAKE CONTOUR LINES
## Note, bandwidth choice is based on MASS::bandwidth.nrd()
kde <- bkde2D(dat[ , list(longitude, latitude)],
              bandwidth=c(.0045, .0068), gridsize = c(100,100))
CL <- contourLines(kde$x1 , kde$x2 , kde$fhat)

## EXTRACT CONTOUR LINE LEVELS
LEVS <- as.factor(sapply(CL, `[[`, "level"))
NLEV <- length(levels(LEVS))

## CONVERT CONTOUR LINES TO POLYGONS
pgons <- lapply(1:length(CL), function(i)
    Polygons(list(Polygon(cbind(CL[[i]]$x, CL[[i]]$y))), ID=i))
spgons = SpatialPolygons(pgons)

## Leaflet map with polygons
leaflet(spgons) %>% addTiles() %>% 
    addPolygons(color = heat.colors(NLEV, NULL)[LEVS])


## Leaflet map with points and polygons
## Note, this shows some problems with the KDE, in my opinion...
## For example there seems to be a hot spot at the intersection of Mayfield and
## Fillmore, but it's not getting picked up.  Maybe a smaller bw is a good idea?

leaflet(spgons) %>% addTiles() %>%
    addPolygons(color = heat.colors(NLEV, NULL)[LEVS]) %>%
    addCircles(lng = dat$longitude, lat = dat$latitude,
               radius = .5, opacity = .2, col = "blue")



## Leaflet map with polygons, using Spatial Data Frame
## Initially I thought that the data frame structure was necessary
## This seems to give the same results, but maybe there are some 
## advantages to using the data.frame, e.g. for adding more columns
spgonsdf = SpatialPolygonsDataFrame(Sr = spgons,
                                    data = data.frame(level = LEVS),
                                    match.ID = TRUE)
leaflet() %>% addTiles() %>%
    addPolygons(data = spgonsdf,
                color = heat.colors(NLEV, NULL)[spgonsdf@data$level])






#####################################################################


d = MapData
config = list(MapState = 'NAT')
d = mapFilteredDT(d, config)


d$dat$postcode = as.integer(d$dat$postcode)
d$loc.info$postcode = as.integer(d$loc.info$postcode)
dat = merge(d$dat, d$loc.info, by = 'postcode', all.x = TRUE)
setnames(d$dat, tolower(colnames(d$dat)))
setnames(d$dat, gsub(" ", "_", colnames(d$dat)))
dat[, lon := as.numeric(lon)]
dat[, lat := as.numeric(lat)]
dat <- dat[!is.na(lon)]

## MAKE CONTOUR LINES
## Note, bandwidth choice is based on MASS::bandwidth.nrd()
kde <- bkde2D(dat[ , list(lon, lat)], bandwidth=c(.0045, .0068), gridsize = c(300,300))
CL <- contourLines(kde$x1 , kde$x2 , kde$fhat)

## EXTRACT CONTOUR LINE LEVELS
LEVS <- as.factor(sapply(CL, `[[`, "level"))
NLEV <- length(levels(LEVS))

## CONVERT CONTOUR LINES TO POLYGONS
pgons <- lapply(1:length(CL), function(i)
    Polygons(list(Polygon(cbind(CL[[i]]$x, CL[[i]]$y))), ID=i))
spgons = SpatialPolygons(pgons)

## Leaflet map with polygons
leaflet(spgons) %>% addTiles() %>% 
    addPolygons(color = heat.colors(NLEV, NULL)[LEVS])





class(d$dat$postcode)

d$dat$postcode = as.integer(d$dat$postcode)
d$loc.info$postcode = as.integer(d$loc.info$postcode)
dat2 = merge(d$dat, d$loc.info, by = 'postcode')







########################################################################
config= list(MapState = 'VIC') #
d = loadDat() #
d = mapFilteredDT(d, config) #
dat = mapDataCleaning(d)
basinDF <- rgdal::readOGR("data/states.geojson", "OGRGeoJSON")
circles <- unique(dat$post.points[, .(postcode, lat, lon)])



leaflet(dat$dat.expand) %>% addProviderTiles(providers$CartoDB.DarkMatter) %>%
    # addBootstrapDependency() %>%
    # enableMeasurePath() %>%
    addPolygons(data=subset(basinDF, STATE_NAME %in% 'Victoria'), weight=2, 
                label = ~htmlEscape(STATE_NAME), 
                popup = ~htmlEscape(STATE_NAME)) %>%
    addPolygons(data=subset(basinDF, STATE_NAME %in% 'New South Wales'), weight=2, 
                label = ~htmlEscape(STATE_NAME), 
                popup = ~htmlEscape(STATE_NAME)) %>%
    addWebGLHeatmap(lng=~lon, lat=~lat, size = 100000, opacity = 0.7, alphaRange = 0.5) %>%
    addCircles(data = circles, lng=~lon, lat=~lat, 
               opacity = 0.3, 
               fill = TRUE, 
               # fillColor = color,
               fillOpacity = 0.1,
               popup = ~htmlEscape(postcode),
               layerId = ~paste(postcode)
    ) %>%
    addLegend(position = "bottomleft", pal=pal, values=variableValue, title='Map Colour Scale',
              layerId="colorLegend", labels = variableValue, bins = 6)
    




basinDF$STATE_NAME

