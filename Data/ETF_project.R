rm(list=ls())
library("rvest")

#Read in iShares country ETF:s
df <- read.table("ETF", header=TRUE)
df <- subset(df, select = c(Country,Ticker,Inception_date,Exp_ratio))



#Desired columns
df$PriceEarning <- NA
df$PriceBook <- NA
df$PriceSales <- NA
df$PriceCashFlow <- NA
df$year_ret <- NA
df$three_month_ret <- NA
df$one_month_ret <- NA

#Function for equity metrics
obtain_equity <- function(ticker){
  web <- gsub("1",ticker,"https://finance.yahoo.com/quote/1/holdings?p=1")
  yahoo <- read_html(web)
  x <- 5
  for(i in 2:5){
    df[ticker, x] <- yahoo %>%
                       html_nodes(xpath=gsub("z", as.character(i),'//*[@id="Col1-0-Holdings-Proxy"]/section/div[2]/div[1]/div/div[z]/span[2]')) %>%
                       html_text()
    x <- x + 1
  }
  return(df[ticker,5:8])
}

#Function for returns (month and year)
obtain_return <- function(ticker){
  web <- gsub("1",ticker,"https://finance.yahoo.com/quote/1/performance?p=1")
  yahoo <- read_html(web)
  x <- 9
  for(i in 5:3){
    df[ticker, x] <- yahoo %>%
                      html_nodes(xpath=gsub("z", as.character(i),'//*[@id="Col1-0-Performance-Proxy"]/section/div[2]/div/div[z]/span[2]')) %>%
                      html_text()
    x <- x + 1
  }
  return(df[ticker,9:11])
}

#Run both scrape functions
for(i in as.character(df$Ticker)){
  df[which(df$Ticker == i), 5:8] <- obtain_equity(i)
  df[which(df$Ticker == i), 9:11] <- obtain_return(i)
  Sys.sleep(1)
}

#Clean "%" from return values
df[,9] <- substr(df[,9], 1, nchar(df[,9])-1)
df[,10] <- substr(df[,10], 1, nchar(df[,10])-1)
df[,11] <- substr(df[,11], 1, nchar(df[,11])-1)

#Change countries containing more than 1 name
df$Country <- as.character(df$Country)

df[which(df$Country == "UnitedKingdom"), "Country"] <- "United Kingdom"
df[which(df$Country == "HongKong"), "Country"] <- "Hong Kong"
df[which(df$Country == "NewZealand"), "Country"] <- "New Zealand"
df[which(df$Country == "SouthAfrica"), "Country"] <- "South Africa"
df[which(df$Country == "SouthKorea"), "Country"] <- "Republic of Korea"
df[which(df$Country == "UAE"), "Country"] <- "United Arab Emirates"
df[which(df$Country == "Russia"), "Country"] <- "Russian Federation"


df$Country <- as.factor(df$Country)

write.csv(df, file = "ETF_data.csv",row.names = FALSE)
