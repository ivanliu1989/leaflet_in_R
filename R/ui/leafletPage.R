renderHeatMaps = function(){
    
    renderUI({
        column(width = 12,
               
            leafletOutput("MapPlot") , 
            
            absolutePanel(top = 30, left = 60, draggable = TRUE, height = "auto",
                          
                          checkboxInput("hideMapConfig","Show/Hide Map Config",value = TRUE),
                          radioButtons("reportType", "Report Type",
                                       c("Summary of Top Destinations" = "topDest",
                                         "Summary of Customers Visiting" = "cstrVisit")),
                          # radioButtons("heatCluster", "Map Type",
                          #              c("WebGL Heatmap" = "heat",
                          #                "Polygon Heatmap" = "cluster")),
                          uiOutput("MapSelectState"),
                          sliderInput("RadiusSize", "Radius Size",
                                      min = 8, max = 18, value = 13
                          ),
                          selectInput("MapProvider","Theme",
                                      c("CartoDB.DarkMatter",
                                        "OpenStreetMap.Mapnik",
                                        "OpenStreetMap.HOT",
                                        "OpenStreetMap.BlackAndWhite",
                                        "Stamen.TonerLite"),
                                      selected = "OpenStreetMap.HOT")
            ),
            uiOutput("stateDetail")
        )
    })
}


uiRenderStateDetailPanel = function(mapClickData){
    renderUI({
        if(!is.null(mapClickData$clickedShape)){
            
            absolutePanel(id = "mapStateDetail", class = "panel panel-default", fixed = TRUE,
                          draggable = TRUE, top = 70, right = 40,
                          height = "auto", width = "40%", 
                          uiOutput("mapStateHeader"),
                          tabBox(id = "mapStatePanel",width = "90%", 
                                 tabPanel("Visits by Postcode", plotlyOutput("MapStatePlot")),
                                 tabPanel("Postcode to Surburb", dataTableOutput("PostToSuburb"))
                                
                          )
            )
        }
    })
}