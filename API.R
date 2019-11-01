library(httr)
library(dplyr)

# example
url=""
headers <- c('Content-Type'='application/json')
payload<-list(
  "from"="",
  "timestamp"=,
  "sign"= "",
  "date"= ""
)

r <- POST(url,add_headers(.headers =headers),body =payload, encode="json",verbose())
r %>% content()->a