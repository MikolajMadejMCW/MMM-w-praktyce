library(tidyverse)
library(readxl)

data.df <- read_excel("sales_data.xlsx")



#### 1 - modeled variable #### 

mod.var.df <- data.df %>%
    select(Date, starts_with("VO_BEER")) %>%
    mutate(ZM_MOD = rowSums(.[,-1])) %>%
    mutate(ZM_MOD = log(ZM_MOD)) %>%
    select(Date, ZM_MOD)


#### 2 - shelf price #### 

price.shelf.1.df <- data.df %>%
    select(Date, starts_with("VO_BEER_SKU"), starts_with("VA_BEER_SKU")) %>%
    pivot_longer(names_to = "variable_name", c(2:ncol(.)))
    
price.shelf.2.df <- price.shelf.1.df %>%
    mutate(TYP = substr(variable_name, 1, 3),
           SKU = substr(variable_name, 4, nchar(variable_name))) %>%
    select(-variable_name) %>%
    pivot_wider(names_from = "TYP", values_from = "value")

price.shelf.3.df <- price.shelf.2.df %>%
    mutate(PR_ = VA_ / VO_)

price.shelf.4.df <- price.shelf.3.df %>%
    pivot_longer(names_to = "variable_name", c(3:ncol(.))) %>%
    mutate(variable_name = paste(variable_name, SKU, sep = "")) %>%
    select(-SKU) %>%
    pivot_wider(names_from = "variable_name", values_from = "value")

# data.df$PR_BEER_SKU1 <- data.df$VA_BEER_SKU1 / data.df$VO_BEER_SKU1



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
    left_join(price.longterm.df) %>%
    select(Date, starts_with("PR"), starts_with("PL")) %>%
    mutate(PS_BEER_SKU1 = (PL_BEER_SKU1 - PR_BEER_SKU1) / (PL_BEER_SKU1)) %>%
    mutate(PS_BEER_SKU2 = (PL_BEER_SKU2 - PR_BEER_SKU2) / (PL_BEER_SKU2)) %>%
    mutate(PS_BEER_SKU3 = (PL_BEER_SKU3 - PR_BEER_SKU3) / (PL_BEER_SKU3)) %>%
    select(Date, starts_with("PS"))

ggplot(price.shortterm.df, aes(c(1:rows), PS_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PS_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PS_BEER_SKU3), color="black")



#### 5 - distribution #### 

distribution.df <- data.df %>%
    select(Date, starts_with("DW_BEER")) %>%
    mutate(DW_BEER = pmax(DW_BEER_SKU1, DW_BEER_SKU2, DW_BEER_SKU3)) %>%
    select(Date, DW_BEER)



