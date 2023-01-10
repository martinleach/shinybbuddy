ui <- fluidPage(navbarPage("Birdbuddy Dashboard (Data: December 2022)", id = "nav", 
             fluidRow( align = 'right',
                       column(6, align="left", 
                              selectInput(inputId = "stateselected", label = "State", choices = dfStates$state, selected="All")),
                       column(6, align="left", 
                              selectInput(inputId = "speciesselected", label = "Species", choices = dfpivot$species_name, selected="carolina wren")))),
             leafletOutput("mymap",height = 600)
)
