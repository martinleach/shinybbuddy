library(dplyr)
library(tidyr)
library(shiny)
library("shinyWidgets")
library(leaflet)
library(pivottabler)
library(maps)

bbuddy <- read.csv("~/birdbuddy/all_metadata_december.csv")

pt <- PivotTable$new()
pt$addData(bbuddy)
pt$addRowDataGroups("species_name")
pt$defineCalculation(calculationName="TotalObs", summariseExpression = "n()")
pt$sortRowDataGroups(levelNumber=1, orderBy="calculation", sortOrder="desc")
pt$renderPivot()

dfpivot <- pt$asDataFrame(rowGroupsAsColumns = TRUE)

bbuddy$State <-map.where(database="state", bbuddy$anonymized_longitude, bbuddy$anonymized_latitude)
statelist = sort(unique(bbuddy$State))
dfStates <- data.frame(matrix(unlist(statelist), nrow=length(statelist), byrow=TRUE))
colnames(dfStates)[1] ="state"

new_row = c("All")
dfStates <- rbind(dfStates,new_row)

medianLat = 0
medianLon = 0
df <- bbuddy  %>% filter(species_name == "carolina wren")
df <- unique( df[ , c('anonymized_latitude','anonymized_longitude','timestamp','species_name') ] )
