library(tidyverse)
library(readxl)

data.df <- read_excel("data_processing.xlsx")


#### media ####
media.df <- data.df %>%
    select(Date, starts_with("TV"))
    
colSums(is.na(media.df))

rows <- nrow(media.df)

ggplot(media.df, aes(c(1:rows), TV_10)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), TV_15), color="red") +
    geom_line(aes(c(1:rows), TV_30), color="black") 
    
media.df[is.na(media.df)] <- 0


# excelowa funkcja "wyszukaj pionowo" w R
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
    

media.adstock.df <- media.prep.df %>%
    mutate(TV_ADS60 = c(28.99400, rep(NA, 155))) 


# przekształcenie adStock 60%
n <- 0.6

for (i in 2:rows) {
    media.adstock.df[i,3] <- media.adstock.df[i,2] * (1-n) + media.adstock.df[i-1,3] * n
}

sum(media.adstock.df$TV)
sum(media.adstock.df$TV_ADS60)

ggplot(media.adstock.df, aes(c(1:rows), TV)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), TV_ADS60), color="red") 

ggplot(media.adstock.df, aes(c(1:rows), TV_ADS60)) +
    geom_line(color="red") 

ggplot(media.adstock.df, aes(c(1:rows), atan(TV_ADS60))) +
    geom_line(color="red") 


database.df <- data.df %>%
    left_join(media.adstock.df) %>%
    select(-TV_15, -TV_10, -TV_30)

rm(list=setdiff(ls(), "database.df"))

sort(colnames(database.df))
sum(is.na(database.df))
