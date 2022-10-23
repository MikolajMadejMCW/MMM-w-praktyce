library(tidyverse)
library(readxl)

data.df <- read_excel("data_processing.xlsx")

#### 1 - modeled variable #### 

#### 2 - shelf price #### 

#### long-term price #### 

price.df <- XXX %>%                    # w miejsce XXX podklej wynik zadania 2
    select(Date, starts_with("PR"))

price.longterm.df <- price.df %>%
    mutate(PL_BEER_SKU1 = 120,
           PL_BEER_SKU3 = 100,
           PL_BEER_SKU2 = c(rep(130, 56), rep(150, rows - 56))) %>%
    select(Date, starts_with("PL"))

ggplot(price.longterm.df, aes(c(1:rows), PL_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PL_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PL_BEER_SKU3), color="black")

#### 3 - short-erm price #### 

#### 4 - distribution #### 

#### 5 - inflation ####

#### 6 - media - inputacja braków ####

#### 7 - media - indeksy ####

tv.dict = c("TV_45" = 1.50,
            "TV_30" = 1.00,
            "TV_20" = 0.85,
            "TV_15" = 0.70,
            "TV_10" = 0.55)

#### 8 - media - AdStock ####

#### 9 - media - laczenie bazy ####
