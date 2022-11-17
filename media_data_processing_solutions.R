library(tidyverse)
library(readxl)

data.df <- read_excel("data_processing.xlsx")

#### 6 - inputacja brakow danych zerem ####


media.df <- data.df %>%
    select(Date, starts_with("TV"))
    
colSums(is.na(media.df))

rows <- nrow(data.df)
ggplot(media.df, aes(c(1:rows), TV_10)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), TV_15), color="red") +
    geom_line(aes(c(1:rows), TV_30), color="black") 
    

# media.df[2:3,2:4]
media.df[is.na(media.df)] <- 0

  
ggplot(media.df, aes(c(1:rows), TV_10)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), TV_15), color="red") +
    geom_line(aes(c(1:rows), TV_30), color="black") 




#### 7 - wykorzystanie slownika na wzor wyszukaj pionowo z excela ####

tv.dict = c("TV_45" = 1.50,
            "TV_30" = 1.00,
            "TV_20" = 0.85,
            "TV_15" = 0.70,
            "TV_10" = 0.55)

media.prep.df <- media.df %>%
    pivot_longer(names_to = "variable_name", c(2:ncol(.))) %>%
    mutate(idx = tv.dict[variable_name]) %>%
    mutate(final_value = value * idx) %>%
    select(-value, -idx) %>%
    pivot_wider(names_from = "variable_name", values_from = "final_value") %>%
    mutate(TV = rowSums(.[,-1])) %>%
    select(Date, TV)
    
ggplot(media.prep.df, aes(c(1:rows), TV)) +
    geom_line(color="blue") 



#### 8 - AdStock ####

media.adstock.df <- media.prep.df %>%
    mutate(TV_ADS80 = c(28.99400, rep(NA, 155))) 

# AdStock 80%
n <- 0.8

for (i in 2:rows) {
    media.adstock.df[i,3] <- media.adstock.df[i,2] * (1-n) + media.adstock.df[i-1,3] * n
}

sum(media.adstock.df$TV)
sum(media.adstock.df$TV_ADS80)

ggplot(media.adstock.df, aes(c(1:rows), TV)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), TV_ADS80), color="red") 



#### 9 - database Join ####

database.df <- data.df %>%
    select(-starts_with("TV_")) %>%
    left_join(media.adstock.df) 

rm(list = setdiff(ls(), "database.df"))

sum(is.na(database.df))
