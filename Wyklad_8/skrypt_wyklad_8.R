library(tidyverse)
library(readxl)

data.df <- read_excel("sales_data.xlsx")



#### 1 - modeled variable #### 

mod.var.df <- data.df %>%
    # ...
    

#### 2 - shelf price #### 

price.shelf.1.df <- data.df %>%
    # ...
    
price.shelf.2.df <- price.shelf.1.df %>%
    # ...

price.shelf.3.df <- price.shelf.2.df %>%
    # ...

price.shelf.4.df <- price.shelf.3.df %>%
    # ...


#### 3 - longterm price #### 

price.df <- price.shelf.4.df %>%
    select(Date, starts_with("PR"))

rows <- nrow(price.df)

ggplot(price.df, aes(c(1:rows), PR_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PR_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PR_BEER_SKU3), color="black")

apply(price.df[,2:(ncol(price.df))], 2, median)
table(price.df$PR_BEER_SKU2)

price.longterm.df <- price.df %>%
    mutate(PL_BEER_SKU1 = 120,
           PL_BEER_SKU3 = 100,
           PL_BEER_SKU2 = c(rep(130, 56), rep(150, rows - 56))) %>%
    select(Date, starts_with("PL"))

ggplot(price.longterm.df, aes(c(1:rows), PL_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PL_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PL_BEER_SKU3), color="black")



#### 4 - shorterm price #### 

price.shortterm.df <- price.shelf.4.df %>%
    # ...

ggplot(price.shortterm.df, aes(c(1:rows), PS_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PS_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PS_BEER_SKU3), color="black")



#### 5 - distribution #### 

distribution.df <- data.df %>%
    # ...



#### 6 - shop weights #### 

shop.weights.df <- data.df %>%
    # ...
    

