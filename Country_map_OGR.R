rm(list=ls())
library("rgdal")
library("shiny")
library("leaflet")
library("dplyr")
library("DT")

df <- read.csv("/Data/ETF_data.csv")
url <- "https://raw.githubusercontent.com/datasets/geo-boundaries-world-110m/master/countries.geojson"
res <- readOGR(dsn = url, layer = "OGRGeoJSON")

#Create new columns for financial metrics
res@data$PriceEarning <- NA
res@data$PriceBook <- NA
res@data$PriceSales <- NA
res@data$PriceCashFlow <- NA
res@data$year_ret <- NA
res@data$three_month_ret <- NA
res@data$one_month_ret <- NA
res@data$totalrank <- NA


#Rank Equity metrics from lowest to highest then sum the total rank to get an overall score
df$perank <- rank(df$PriceEarning)
df$pbrank <- rank(df$PriceBook)
df$psrank <- rank(df$PriceSales)
df$pcfrank <- rank(df$PriceCashFlow)

df$totalrank <- df %>% select(perank:pcfrank) %>% rowSums(na.rm=TRUE)
df$totalrank <- rank(df$totalrank)

#Iterate over countries and assign financial metric from ETF value
for(i in 1:177){
  if(as.character(res@data$name_long[i]) %in% df$Country){
    res@data$PriceEarning[i] <- as.numeric(df[which(df$Country 
                                                    ==as.character(res@data$name_long[i])) ,"PriceEarning"])
    res@data$PriceBook[i] <- as.numeric(df[which(df$Country 
                                                 ==as.character(res@data$name_long[i])) ,"PriceBook"])
    res@data$PriceSales[i] <- as.numeric(df[which(df$Country 
                                                  ==as.character(res@data$name_long[i])) ,"PriceSales"])
    res@data$PriceCashFlow[i] <- as.numeric(df[which(df$Country 
                                                     ==as.character(res@data$name_long[i])) ,"PriceCashFlow"])
    res@data$year_ret[i] <- as.numeric(df[which(df$Country 
                                                ==as.character(res@data$name_long[i])) ,"year_ret"])
    res@data$three_month_ret[i] <- as.numeric(df[which(df$Country 
                                                       ==as.character(res@data$name_long[i])) ,"three_month_ret"])
    res@data$one_month_ret[i] <- as.numeric(df[which(df$Country 
                                                     ==as.character(res@data$name_long[i])) ,"one_month_ret"])
    res@data$totalrank[i] <- df[which(df$Country 
                                      ==as.character(res@data$name_long[i])) ,"totalrank"]
  }
}

#Run the app locally
#shinyApp(ui = ui, server = server)

