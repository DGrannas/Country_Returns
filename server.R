library("shiny")
library("leaflet")
library("dplyr")
library("DT")

#Color palette used for returns
bins <- c(-Inf, -20, -10, -5, 0, 5, 10, 20, 30, Inf)
colors <- c("#b30000","#e34a33","#fc8d59","#fdcc8a","#f1eef6","#d0d1e6","#a6bddb","#74a9cf","#2b8cbe","#045a8d")


server <- function(input, output, session){
  
  output$CountryMap <- renderLeaflet({
    leaflet(res) 
  })
  
  observe({
    
    metric <- input$metric
    metricData <- res@data[,metric]
    #Output and colors if return metric is selected
    if (metric == "year_ret" | metric == "three_month_ret" | metric == "one_month_ret") {
      leafletProxy("CountryMap", data = res) %>%
        clearShapes() %>%
        setView(lng=0.878906, lat=40.601441, zoom=2) %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorBin(colors, metricData, bins= bins)(metricData),
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE),
                    label = ~paste0(sovereignt, ": ", formatC(metricData, big.mark = ","))) %>%
        addLegend(pal = colorBin(colors, metricData, bins= bins), values = ~metricData, opacity = 0.7, title = NULL,
                  position = "bottomleft", layerId = 1)
      
    } else {
      #Output and colors if equity metric is selected
      leafletProxy("CountryMap", data = res) %>%
        clearShapes() %>%
        setView(lng=0.878906, lat=40.601441, zoom=2) %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.5,
                    fillColor = ~colorBin("Blues", metricData, bins=8, reverse=TRUE)(metricData),
                    highlightOptions = highlightOptions(color = "white", weight = 2,
                                                        bringToFront = TRUE),
                    label = ~paste0(sovereignt, ": ", formatC(metricData, big.mark = ","))) %>%
        addLegend(pal = colorBin("Blues", metricData, bins=8, reverse=TRUE), values = ~metricData, opacity = 0.7, title = NULL,
                  position = "bottomleft", layerId = 1)
      
    }
  })
  #Output of the datatable
  output$countrytable <- DT::renderDataTable({
    data <- df
    action <- DT::dataTableAjax(session, data)
    
    DT::datatable(data, extensions = "Scroller",options = list(scrollX=TRUE,scrollY="400px", ajax = list(url = action)), escape = FALSE)
  })
  
}