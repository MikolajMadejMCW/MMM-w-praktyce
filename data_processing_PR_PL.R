library(tidyverse)
library(readxl)

data.df <- read_excel("data_processing.xlsx")



#### 1 - modeled variable #### 10 min 

mod.var.df <- data.df %>%
    select(Date, starts_with("VO_BEER")) %>%
    mutate(ZM_MOD = rowSums(.[,-1])) %>%
    mutate(ZM_MOD = log(ZM_MOD)) %>%
    select(Date, ZM_MOD)

ggplot(mod.var.df, aes(c(1:nrow(mod.var.df)), ZM_MOD)) +
    geom_line(color="blue") 



#### 2 - shelf price #### 15 min

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


rows <- nrow(price.shelf.4.df)

ggplot(price.shelf.4.df, aes(c(1:rows), PR_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PR_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PR_BEER_SKU3), color="black")




#### longterm price #### 0 min

price.df <- price.shelf.4.df %>%
    select(Date, starts_with("PR"))

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


