installIfNotExisits = function(x){
    allPkgs = installed.packages()
    if(!x%in%allPkgs){
        install.packages(x)
    }
}
installIfNotExisits("leaflet")
installIfNotExisits("data.table")
installIfNotExisits("sp")
installIfNotExisits("rgdal")
installIfNotExisits("data.table")
installIfNotExisits("checkmate")
installIfNotExisits("scales")
installIfNotExisits("googleVis")
installIfNotExisits("testthat")
installIfNotExisits("RColorBrewer")
installIfNotExisits("shiny")
installIfNotExisits("shinydashboard")
installIfNotExisits("shinyjs")
installIfNotExisits("DT")
installIfNotExisits("stringr")
installIfNotExisits("rjson")
installIfNotExisits("splitstackshape")
installIfNotExisits("htmltools")
installIfNotExisits("KernSmooth")
installIfNotExisits("ggplot2")
installIfNotExisits("plotly")
installIfNotExisits("gridExtra")
allPkgs = installed.packages()
if(!'leaflet.extras'%in%allPkgs){
    devtools::install_github('rstudio/leaflet')
    devtools::install_github('bhaskarvk/leaflet.extras')
}


cl =function() {rm(list = ls(envir = .GlobalEnv), envir = .GlobalEnv);gc();cat("\014")}
countNAs = function(x){sum(is.na(x))}

library(leaflet)
library(data.table)
library(sp)
library(rgdal)
library(data.table)
library(checkmate)
library(scales)
library(googleVis)
library(testthat)
library(RColorBrewer)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(DT)
library(stringr)
library(leaflet.extras)
library(rjson)
library(htmltools)
library(KernSmooth)
library(ggplot2)
library(plotly)
library(gridExtra)


# comms
source("R/ui/renderPages.R")
source("R/ui/leafletControls.R")
source("R/utilities/loadMainData.R")
source("R/ui/leafletPage.R")
source("R/visualisation/leafletMainFunctions.R")
source("R/utilities/formatting.R")

