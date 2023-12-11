library(tidyverse)
library(readxl)
library(lubridate)


#### Zajecia 10 - czynniki zewnetrzne cz.2 ####

# zad 1) Na podstawie dziennych wartosci temperatury z pliku pogoda.xlsx stworz dane o
#        czestotliwosci tygodniowej w podziale na miejscowosci (station.name) dla okresu
#        od 2018-12-31 do 2022-05-28.


weather.raw.df <- read_excel()

zad.1.df <- weather.raw.df %>%
            mutate(Date = as.Date(Date)) %>%
            filter(Date >= "2018-12-31" & Date <= "2022-05-28") %>%
            mutate(Date.weekly = floor_date(Date, unit = "weeks", 1)) %>%
            group_by(Date.weekly, station.name) %>%
            summarize(TEMP_MEAN = mean(TEMP)) %>%
            ungroup()


# zad 2) Polacz dane pogodowe ze slownikiem wojewodztw (zakladka slownik) i policz
#    srednia temperature per tydzien i wojewodztwo


voi.df <- read_excel( ,
                     sheet = "slownik")

zad.2.df <- zad.1.df %>%
    left_join(voi.df) %>%
    group_by(Date.weekly,voi) %>%
    summarize(TEMP_MEAN_VOI = mean(TEMP_MEAN)) %>%
    ungroup()


# zad 3) Zlacz dane z punktu 2 z wagami okreslajacymi udzial populacji wojewodztw,
#    stosujac wagi z zakladki wagi. Nastepnie policz srednia wazona temperature dla calego kraju


weights.df <- read_excel( ,
                         sheet = "wagi")
    
zad.3.df <- zad.2.df %>%
    left_join(weights.df) %>%
    mutate(TEMP_X_WEIGHT = weight * TEMP_MEAN_VOI) %>%
    group_by(Date.weekly) %>%
    summarize(TEMP_WEIGHTED = sum(TEMP_X_WEIGHT)) %>%
    ungroup()


# zad 4) Do dataframu z zadania 3 dolacz numery tygodnia z arkusza 
#         nrtygodnia (nr tygodnia to cykl liczb od 1 do 52)


week.number.df <- read_excel( ,
                             sheet = "nrtygodnia")
    
zad.4.df <- zad.3.df %>%
    left_join(week.number.df, by = c("Date.weekly" = "Date"))


# zad 5) Policz cykl temperatury poprzez policzenie sredniej temperatury dla kazdego numeru tygodnia


zad.5.df <- zad.4.df %>%
    group_by(week.no) %>%
    summarise(TEMP_NORM = mean(TEMP_WEIGHTED))


# zad 6) Stworz finalny dataframe z wartosciami cyklu temperatury dla okresu od 2018-12-31 do 2022-05-23,
#    laczac dataframy z punktow 4 i 5


zad.6.df <- week.number.df %>%
    left_join(zad.5.df)

