# all against all correlation and heatmap

library(dplyr)
bbuddy <- read.csv("~/birdbuddy/all_metadata_december.csv")

bbuddyFilt <- select(bbuddy, species_name,anonymized_latitude,anonymized_longitude)
bbuddyFiltUnq <- unique( bbuddyFilt[ , c('species_name','anonymized_latitude','anonymized_longitude') ] )

# create location (x,y)
bbuddyFiltUnq$xy <- paste("(",bbuddyFiltUnq$anonymized_latitude,",",bbuddyFiltUnq$anonymized_longitude,")")

# create unique list of birds
birdlist = sort(unique(bbuddyFiltUnq$species_name))

# create list of locations
locationlist = sort(unique(bbuddyFiltUnq$xy))

# create new df
locationDF <- data.frame(matrix(0, nrow=length(locationlist), ncol=length(birdlist), byrow=TRUE))

x <- birdlist
colnames(locationDF) <- x

row.names(locationDF) <- locationlist


# iterate through unique list and update bird for each location from unique list created

for (row in 1:nrow(bbuddyFiltUnq)) {
  species_name <- bbuddyFiltUnq[row, "species_name"]
  location <- bbuddyFiltUnq[row, "xy"]
  print(location)
  print(species_name)
  locationDF[location,species_name] = 1
}


######

library(corrplot)
M = cor(locationDF)

#corrplot(M, order = 'hclust', addrect = 20)

testRes = cor.mtest(locationDF, conf.level = 0.95)
corrplot(M, p.mat = testRes$p, method = 'circle', type = 'lower', insig='blank', tl.col='black',tl.offset = 0,tl.srt = 90,
        number.cex = 0.8, order = 'AOE', diag=FALSE)

#cormat <- round(cor(locationDF),2)
#head(cormat)

# install and load the plotly package
#library(plotly)
# library(ggcorrplot)
# 
# ggcorrplot::ggcorrplot(cor(locationDF))

# create corr matrix and
# corresponding p-value matrix
# p_mat <- cor_pmat(locationDF)
# 
# # plotting the interactive corr heatmap
# corr_mat <- ggcorrplot(
#   corr_mat, hc.order = TRUE, type = "lower",
#   outline.col = "white",
#   p.mat = p_mat
# )
# 
# ggplotly(corr_mat)
