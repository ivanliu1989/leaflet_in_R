# http://rstudio.anzinsights.com/shiny/rstudio/NRMA_Heatmap/
source("R/utilities/sourceFiles.R")

header <- dashboardHeader(
    title = "NRMA Maps",
    uiOutput("MapTitle")
)

sidebar = dashboardSidebar(
    useShinyjs(),
    uiOutput("dashBoardSideBar")
    ,actionButton("debug", "DEBUG")
    
)

body = dashboardBody(
    tags$head(tags$style(HTML(".sidebar {height: 90vh; overflow-y: auto;}"))),
    tags$head(tags$style(".smallfont {font-size:14px;}")),
    tags$head(tags$style(".smallfont td {padding:1px 2px !important;}")),
    tags$head(tags$style(".smallfont caption {text-align:center;font-weight:bold}")),
    tags$head(tags$style(".wrapper {background-color: #ecf0f5 !important;}")),
    tags$head(tags$style(".nonpadded-column {padding:0; margin-left: -15px;margin-right: -15px;}")),
    
    tags$style(type = "text/css", ".panel {opacity:0.80;}"),
    tags$style(type = "text/css", "#mapStatePanel {margin:10px}"),
    tags$script("$(function() {$.fn.dataTableExt.errMode = function(settings, tn, msg) { console.log(msg); };});"),
    tags$style(type = "text/css", "#MapPlot {height: calc(100vh - 100px) !important;}"),
    tags$style(type = "text/css", "#mapStateHeader {font-weight:bold;font-size:18px;margin:10px}"),
    tags$style(type = "text/css", "#MapTitle {font-weight:bold;font-size:20px;margin:10px;
               align:left !important;
               text-align:left !important;
               color: #000000;}"),
    
    tags$head(tags$style(type="text/css", "
                         #loadmessage {
                         position: fixed;
                         top: 0px;
                         left: 0px;
                         width: 100%;
                         height: 100%;
                         padding: 5px 0px 5px 0px;
                         text-align: center;
                         font-weight: bold;
                         font-size: 100%;
                         color: #000000;
                         background-color: #efecec;
                         z-index: 10005;
                         }
                         @keyframes spinner {
                         to {transform: rotate(360deg);}
                         }
                         
                         .spinner:before {
                         content: '';
                         box-sizing: border-box;
                         position: absolute;
                         top: 50%;
                         left: 50%;
                         width: 100px;
                         height: 100px;
                         margin-top: -50px;
                         margin-left: -50px;
                         border-radius: 50%;
                         border: 20px solid #ccc;
                         border-top-color: #333;
                         animation: spinner .6s linear infinite;
                         }
                         
                         body.disconnected{background-color: red;}
                         
                         ")),
    div(id = "loading-initial", class = "busy"),
    conditionalPanel(condition="$('#loading-initial').hasClass('busy')",
                     tags$div(div(class = "spinner") ,id="loadmessage")),
    renderTabLayout(),
    uiOutput("reportNameText", class = "reportName")
    # imageOutput("anzLogo",width = "106px", height = "106px")
)

dashboardPage(header, sidebar, 
              body, skin = "blue")