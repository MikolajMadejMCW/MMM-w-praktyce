library(tidyverse)
library(readxl)
library(lubridate)


#### Zajecia 9 - czynniki zewnetrzne cz.1 ####

# zad 1) Wczytaj dane covidowe (covid_google_mobility_data.csv)
#        W osobnej ramce wybierz zmienna date i zmienna Mobility index dla retailu (kolumna retail_and_recreation_percent_change_from_baseline),
#        nazwij ja MOBILITY_RETAIL
#        Zamien czestotliwosc dzienna na tygodniowa, liczac srednia z 7 dni dla kazdego tygodnia


covid.df <- read.csv2() %>%
    slice(1:974)

zad1.df <- covid.df %>%
    select(date, MOBILITY_RETAIL = retail_and_recreation_percent_change_from_baseline) %>%
    mutate(week_date = floor_date(ymd(date), unit = "weeks", week_start = 1)) %>%
    group_by(week_date) %>%
    summarise(MOBILITY_RETAIL = mean(MOBILITY_RETAIL))


#---------------------------------------------------------------
    
# 
# zad 2) Zestaw zmienne mobility index retail i residential (w czestotliwosci dziennej) na wykresie liniowym
#        Zadbaj o to, by wykres byl czytelny

ggplot(covid.df) + 
geom_line(aes(x = as.Date(date), y = as.numeric(retail_and_recreation_percent_change_from_baseline)), color = "blue") + 
geom_line(aes(x = as.Date(date), y = as.numeric(residential_percent_change_from_baseline)), color = "green") +
  xlab("Date") +
  ylab("Mobility index") 
    

#---------------------------------------------------------------

# 
# zad 3) Stworz data frame ze zmienna Date, 
#        ktora przyjmuje wartosci tygodniowe dat od 2021-01-04 do 2022-05-23.
#        Mozesz zastosowac funkcje seq()

Date <- c(seq(as.Date("2021-01-04"), as.Date("2022-05-23"), by = "weeks")) 
Date <- c(seq(as.Date("2021-01-04"), as.Date("2022-05-23"), by = 7))
zad3.df <- as.data.frame(Date)


#---------------------------------------------------------------
    
# 
# zad 4) Stworz 3 zmienne w okresie podanym w zadaniu 2:
#        a) XMAS, ktora przyjmuje wartosc 1 dla 25 grudnia kazdego roku
#        b) EASTER, ktora przyjmuje wartosci 1 dla Niedzieli Wielkanocnej w kazdym roku
#        c) Y2022, ktora przyjmuje wartosci 1 dla wszystkich dat w 2022 roku

# rozwiazanie punktu a z zajec
zad4a.df <- zad3.df %>% 
  mutate(XMAS = case_when(
    month(Date) == 12 & day(Date) == 20 ~ 1,
    TRUE ~ 0
  ))

# rozwiazanie punktu c z zajec
zad.4c.df <- zad3.df %>%
  mutate(Year = year(Date),
         Y2022 = ifelse(Year == "2022", 1, 0)) %>%
  select(-Year)

# inne rozwiazanie punktow a-c   
zad4.df <- data.df %>%
    mutate(XMAS = ifelse(Date == ymd("2021-12-20"), 1, 0),
           EASTER = ifelse(Date == ymd("2021-03-29")| Date == ymd("2022-04-11"), 1,0),
           Y2022 = ifelse(Date >= ymd("2022-01-03"), 1,0))
    
#---------------------------------------------------------------
    
# 
# zad 5) Wczytaj dane sales_data.xlsx
#        Na podstawie zmiennej INFLACJA_WOW (wspolczynnik inflacji tydzien vs poprzedni tydzien) przygotuj zmienne:
#        a) INFLACJA_BASE - skumulowany wspolczynnik inflacji w odniesieniu do pierwszego tygodnia
#        c) INFLACJA_SMOOTH - scentrowana srednia ruchoma z 5 tygodni policzona na podstawie zmiennej INFLACJA_BASE


sales.df <- read_excel( ) 

zad5.df <- sales.df %>%
  select(Date, INFLACJA_WOW) %>%
  mutate(INFLACJA_BASE = cumprod(INFLACJA_WOW)) %>%
  mutate(INFLACJA_SMOOTH = (INFLACJA_BASE - 1 +
                              lag(INFLACJA_BASE, 1, default = 1.001) - 1 +
                              lag(INFLACJA_BASE, 2, default = 1.001) - 1 +
                              lead(INFLACJA_BASE, 1, default = 1.1854479) - 1 +
                              lead(INFLACJA_BASE, 2, default = 1.1854479) - 1) / 5 + 1)




    
    

    