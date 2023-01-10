server <- function(input,output, session){
  
  data <- reactive({
    x <- df
    if (input$stateselected =="All"){
      df <- filter(bbuddy,(species_name == input$speciesselected))
    }
    else{
      df <- filter(bbuddy,(species_name == input$speciesselected) & (State == input$stateselected))
    }
    x <- unique( df[ , c('anonymized_latitude','anonymized_longitude','timestamp','species_name') ] )
  })  
  
  output$mymap <- renderLeaflet({
    df <- data()
    maxLat = max(df$anonymized_latitude)
    maxLon = max(df$anonymized_longitude)
    minLat = min(df$anonymized_latitude)
    minLon = min(df$anonymized_longitude)
    
    m <- leaflet(data = df, options = leafletOptions(zoomControl = FALSE)) %>%
      addTiles() %>%
      addCircleMarkers(lng = ~anonymized_longitude, 
                 lat = ~anonymized_latitude,
                 color ="red",
                 radius=4,
                 stroke = FALSE, fillOpacity = 5) 
    
    m %>% addProviderTiles(providers$CartoDB.Positron)
    m %>% fitBounds(lat1=minLat,lng1=minLon,lat2=maxLat,lng2=maxLon)
  })
  
}