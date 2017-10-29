source("R/utilities/sourceFiles.R")
options(shiny.maxRequestSize=100*1024^2)
options(stringsAsFactors = F)

MapData = loadDat()
basinDF <- rgdal::readOGR("data/states.geojson", "OGRGeoJSON")

shinyServer(function(input, output) {

    
    observeEvent(input$debug, browser())
    
    output$dashBoardSideBar = renderUI({
        sideBarContent(MapData)
    })
    
    output$heatmapUI = renderHeatMaps()
    
    # Leaflet Map -------------------------------------------------------------
    output$MapSelectState = renderUI({
        dat = loadDat()
        states = mapSelectState(dat)
        if(input$reportType == "topDest"){
            selectInput("SelectState", "Select State", choices = states[1],
                        selected = states[1],
                        size=6, selectize = F)
        }else{
            selectInput("SelectState", "Select State", choices = states[-1],
                        selected = states[2],
                        size=6, selectize = F)
        }
        
    })
    
    MapRelativeValue = eventReactive(input$MapRelative, {
        return(input$MapRelative)
    })
    
    MapDataSet = reactive({
        d = loadDat()
        config = list(MapState = 'NAT')
        d = mapFilteredDT(d, config)
        d = mapDataCleaning(d)
    })
    
    MapFilteredData = reactive({
        d = loadDat()
        config = list(MapState = ifelse(is.null(input$SelectState), 'NAT', input$SelectState))
        d = mapFilteredDT(d, config)
        d = mapDataCleaning(d)
        
        return(d)
    })

    output$MapPlot <- renderLeaflet({
        dat = MapFilteredData()
        config = list(RadiusSize = ifelse(is.null(input$RadiusSize), 10, input$RadiusSize),
                      SelectState = ifelse(is.null(input$SelectState), 'NAT', input$SelectState),
                      MapProvider = ifelse(is.null(input$MapProvider), 'OpenStreetMap.Mapnik', input$MapProvider),
                      # MapType = ifelse(is.null(input$heatCluster), 'heat', input$heatCluster),
                      ReportType = ifelse(is.null(input$reportType), 'topDest', input$reportType)
                      )
        m = generateLeaflet(dat, config, basinDF)
        return(m)
    })
    
    output$MapTitle <- renderUI({
        
        if(!is.null(input$SelectState)){
            states = mapSelectState(loadDat())
            selectedState = ifelse(is.null(input$SelectState), 'NAT', input$SelectState)
            displayState = names(states)[states == selectedState]
            
            if(selectedState != 'NAT'){
                msg = paste0("Summary of Customers Visiting - ", displayState)
            }else if(selectedState == 'NAT'){
                msg = paste0("Summary of Top Destinations - ", displayState)
            }else{
                msg = ""
            }
        }else{
            msg = "Please click Open Maps on the side bar to start."
        }
        return(msg)
    })
    
    observe({
        if(!is.null(input$SelectState)){
            gc()
            toggle(id = "MapSelectState", condition = input$hideMapConfig)
            toggle(id = "MapProvider", condition = input$hideMapConfig)
            toggle(id = "MapRelative", condition = input$hideMapConfig)
            # toggle(id = "heatCluster", condition = input$hideMapConfig)
            toggle(id = "RadiusSize", condition = input$hideMapConfig)
        }

    })
    
    mapClickData <- reactiveValues(clickedShape=NULL)
    
    observeEvent(input$MapPlot_shape_click,{
        print("marker clicked")
        if(!(input$reportType == 'cstrVisit' & input$MapPlot_shape_click$id == 'New South Wales'))
            mapClickData$clickedShape <- input$MapPlot_shape_click
    })
    
    observeEvent(input$MapPlot_click,{
        mapClickData$clickedShape <- NULL
    })
    
    output$stateDetail = uiRenderStateDetailPanel(mapClickData)
    
    observeEvent(input$MapPlot_marker_mouseover$id, {
        print("hovered")
        hoverId = input$MapPlot_marker_mouseover$id
        d = MapFilteredData()
        suburb = unique(d$loc.info[postcode == hoverId, suburb])
        visits = d$dat[postcode == hoverId, visits]
        
        msg = paste('<b>Postcode:</b> ', hoverId, "<br><b>Suburb:</b> ", paste0(suburb, collapse = ','), "<br><b>Total visits:</b> ", visits)
        offset = isolate((input$MapPlot_bounds$north - input$MapPlot_bounds$south) / (23 + (18 - input$MapPlot_zoom)^2 ))
        leafletProxy("MapPlot", data = d) %>% addPopups(lng = input$MapPlot_marker_mouseover$lng,
                                                        lat = input$MapPlot_marker_mouseover$lat + offset,
                                                        popup = msg)
        print(msg)
    })
    observeEvent(input$MapPlot_marker_mouseout$id, {
        leafletProxy("MapPlot") %>% clearPopups()
    })
    
    observe({
        click<-input$MapPlot_shape_click
        dat = MapFilteredData()
        
        # header
        output$mapStateHeader = renderText({
            return(mapClickData$clickedShape$id)
        })
        
        output$MapStatePlot <- renderPlotly({
            g = topPostPanelPlot(dat, mapClickData$clickedShape$id, input$SelectState)
            return(ggplotly(g))
        })
        
        output$PostToSuburb <- renderDataTable({
            surburb = cleanPostSurburDT(dat, mapClickData$clickedShape$id, input$SelectState)
            d = DT::datatable(surburb, rownames = F)
        })
    })
        
        
    
})

