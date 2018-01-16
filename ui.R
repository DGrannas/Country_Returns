library("shiny")
library("leaflet")
library("DT")

vars <- c(
  "Price/Earnings" = "PriceEarning",
  "Price/Book" = "PriceBook",
  "Price/Sales" = "PriceSales",
  "Price/CashFlow" = "PriceCashFlow",
  "1 Year Returns" = "year_ret",
  "Three Month Returns" = "three_month_ret",
  "One Month Returns" = "one_month_ret",
  "Value Ranking" = "totalrank"
)

ui <- navbarPage("Country Explorer", id="nav",
                 
                 tabPanel("Interactive Map",
                          div(class = "outer",
                              tags$head(
                                # Include our custom CSS
                                includeCSS("style.css")
                              ),
                              #Display the world map
                              leafletOutput("CountryMap",width="100%", height="100%"),
                              
                              #Panel for selecting financial metric
                              absolutePanel(top=40, right=10, draggable=TRUE, style = "opacity: 0.8",
                                            h2("Country Explorer"),
                                            
                                            selectInput("metric", "Options", vars)
                                            
                              )
                          )
                 ),
                 #Display the datatable
                 tabPanel("Data Explorer",
                          div(class = "outer",
                              hr(),
                              DT::dataTableOutput("countrytable",width=1200, height = 800)
                          )
                 ),
                 #General information about project
                 tabPanel("About",
                          sidebarLayout(
                            sidebarPanel(
                              h1("About this project"),
                              p("I built this project to visualize and conceptualize 
                 the financial metrics and returns of the smaller financial 
                 markets in the world. The data is based on iShares MSCI Capped ETF:s
                 and that's why for example the US market is not present on the map."),
                              p("Since data on a lot of countries is hard to acquire and does not exists as
                 ETF:s this is just a small representation of the financial markets. Furthermore,
                 ETF:s are built around the MSCI index and should not be seen as an accurate
                 representation of the countries financial metrics but an approximation."),
                              h2("Code"),
                              p("GitHub: ", a("https://github.com/DGrannas/Country_Returns", 
                                              href="https://github.com/DGrannas/Country_Returns"))
                            ),
                            mainPanel(
                              h1("Data"),
                              p(strong("Price/Earnings: "),
                                "Current price per share divided by last reported earnings of the company"),
                              p(strong("Price/Sales: "),
                                "Current price per share divided by last reported total sales of the company"),
                              p(strong("Price/Book: "),
                                "Current price per share divided by last reported book value of the company"),
                              p(strong("Price/CashFlow: "),
                                "Current price per share divided by last reported cashflow of the company"),
                              p(strong("Value Ranking: "),
                                "The metrics above have been ranked from lowest to highest and then combined in to
                   a ranking of the countries with the best overall rating"),
                              p(strong("Returns: "),
                                "How much has an investment in this ETF/Country approximately yielded in the last
                   month, three month and 1 year period ?")
                            )
                          ))
)