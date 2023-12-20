library(tidyverse)

# Zad 1
database.df <- as.data.frame(seq(as.Date("2018-01-01"), as.Date("2020-12-21"), by="week"))
colnames(database.df) <- "Date"

database.df <- database.df %>%
    mutate(Date = as.Date(Date))


# Zad 2
file_names <- list.files("WASZA ŚCIEŻKA", full.names = TRUE)
pogoda.df <- do.call(rbind,lapply(file_names,function(i){read.csv2(i, sep = ",", head = F)}))