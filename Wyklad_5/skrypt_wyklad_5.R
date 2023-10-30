#### MMM w praktyce - przetwarzanie danych - wyklad  ####
#### Tidyverse 3: joins, lubridate, ggplot ####

#### wczytanie pakietów ####
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyr)
library(readr)

#### MUTATING JOINS ####

# full_join - zachowuje wszystkie wiersze z obu df-ów
# inner_join - zachowuje tylko te wiersze, które pojawiają się w obu df-ach
# left_join - zachowuje wszystkie wiersze z pierwotnej (lewej) tabeli
# right_join - zachowuje wszystkie wiersze z dodawanej (prawej) tabeli

#składnia: 
    #wywołaj funkcję
    #podaj data frame'y, które chcesz łączyć
    #opcjonalnie podaj kolumny, po których łączysz
    #i wiele innych opcji

# złączmy dane z tv oraz tv_pretest, aby mieć wszystkie wiersze z obu z nich
tv.df <- read.csv2("example_TV.csv")
tv.pretest.df <- read.csv2("example_TV_pretest.csv")

tv.filled.df <- tv.df %>% 
    full_join(tv.pretest.df)

# połącz dane pogodowe wybierając tylko te wiersze, które powtarzają się w obu tabelach, 
# jeśli kolumna łączenia inaczej się nazywa, musimy podać ją explicite

weather.df <- read_csv2("example_data_weather.csv")
weather.2.df <- read_csv2("example_data_weather2.csv")

weather.complete.df <- weather.df %>% 
    inner_join(weather.2.df, by = c("Date" = "Week"))

#left_join przydaje się do słownikowania - to ważna sprawa
tv.long.df <- read.csv2('example_data.csv')
tv.long.dict.df <- read.csv2('example_data_dict.csv')

tv.long.df <- tv.long.df %>% 
    left_join(tv.long.dict.df, by = "Brand")

#łączyć można po dowolnej liczbie kolumn, jeśli potrzeba podać ich nzawy, pisze się by = ("a" = "b", "c" = "d")

#po co właściwie jest right_join? 

#### Zadania: mutating joins ####

#Zadanie 0A. Wczytaj pliki example_TV, example_TV_dict, example_TV_dict2, example_YT.csv, example_OLV.csv


    
#Zadanie 1. Połącz dane z YT z danymi OLV tak, aby zachować wszystkie wiersze. Posortuj je po dacie



#Zadanie 2. Zasłownikuj dane example_TV słownikiem example_TV_dict



#Zadanie 3. Obejrzyj dane example_TV i example_TV_dict2. Zasłownikuj jedne drugimi. 



#### LUBRIDATE ####
#jakie macie ustawienie daty na komputerze? 
#bo ważne jest, żeby różni członkowie zespołu mieli to samo

#funkcja as.Date (i as_date) zmienia produkt datopodobny w datę

#w example_dates2b dodaj zmienną binarną przyjmującą wartość 1 w tygodniach rozpoczynających się do końca stycznia 2023 i 0 później
ex.date.2b.df <- read_csv2("example_dates2b.csv")

ex.date.2b.df <- ex.date.2b.df %>% 
    mutate(binary_202301 = ifelse(Date <= "2023-01-31", 1, 0))
#poszło

ex.date.2b.df <- ex.date.2b.df %>% 
    mutate(binary_202301_2 = ifelse(Date <= "23-01-31", 1, 0))
#nie poszło. To znaczy poszło, ale... 

ex.date.2b.df <- ex.date.2b.df %>% 
    mutate(binary_202301_3 = ifelse(Date <= as_date("23-01-31"), 1, 0))
#poszło! 

#funkcja today podaje bieżącą datę
today()
now()

#funkcje year(), month(), date(), hour(), minute() podają odpowiednią jednostkę czasową
year(today())
month("2023-10-01")
#skąd on wie, że to jest 1 października, a nie 10 stycznia? 
hour(now())

#funkcje years(), months(), dates(), hours(), minutes() służą do dodawania odpowiednich jednostek czasu
today() + years(2)
as.Date("2020-10-23") + days(3)
now() - minutes(25)

#months() wymaga czasem nieco uważności
as_date("2023-10-31") + months(1)

#funkcje w typie ymd() przekształcają tekst w datę - i są w tym całkiem dobre
mdy(10012023)
ydm("2023/10/01")
myd("01-23-10")
ydm_hm("2023 15 October, 12:23")

#floor_date zaokrągla dane do wielokrotności jednostki czasu
floor_date(now(), unit = "hours")

as_date("2023-10-15") %>% 
    ceiling_date(unit = "months")

floor_date(today(), "weeks", week_start = 1)
#czy wszyscy wiedzą, że może nie być "unit" i też zadziała? i dlaczego? 

#### Zadania: lubridate ####

#Zadanie 0B. Wczytaj pliki example_dates1, example_dates_2a, example_dates_2b, example_dates_3


#Zadanie 4. Do danych example_dates1 dołącz kolumnę, która określi datę - zadbaj o to, żeby faktycznie była datą



#Zadanie 5. W tabeli example_dates_3 znajdziesz aktywności z poszczególnych dni. Aktywności są automatycznie raportowane przez system do księgowości ostatniego dnia danego miesiąca. Dodaj kolumnę reporting_date, w której oznaczysz, w którym dniu (data) każda z aktywności zostanie zaraportowana



#Zadanie 6*. W danych z pliku example_dates_2a Zmień dane dzienne w dane tygodniowe i dołącz do nich plik 2b
# * oznacza, że za zrobienie w jednym bloku kodu są dwa punkty



#### GGPLOT ####

##ggplot ma konkretną strukturą poleceń
#(total.olv.df uwzyskujemy w zadaniu 1)

ggplot(total.olv.df) + #wywołaj funkcję i podaj jej dane
    geom_line(aes(x = Date, y = YouTube_views), #zdefiniuj podstawowe informacje
              color = 'blue', #i trochę graficznych szczegółów
              linetype = "dotted") 

ggplot(total.olv.df) + 
    geom_point(aes(x = OLV_views, y = YouTube_views), color = 'red') + 
    theme_minimal()   #dodaj dodatki - wygląd

ggplot(total.olv.df) + 
    geom_line(aes(x = Date, y = YouTube_views), color = 'magenta') + 
    xlab("Data") + #dodaj dodatki - inaczej zatytułuj osie
    ylab("YT views") + 
    theme(axis.text.x=element_text(angle=90)) #obróc labelki o 90 stopni

total.olv.df %>% 
    pivot_longer(cols = 2:3) %>% 
    ggplot(.) + 
    geom_line(aes(x = Date, y = value, color = name)) + 
    theme_minimal() #wybierz motyw

#### Zadania: GGPLOT ####
#Do zadań z ggplota zalecam użycie cheat sheeta

#Zadanie 0C. Wczytaj pliki example_TV.csv


#Zadanie 7. Zrób wykres słupkowy, pokazujący koszt (nie ratecard) per marka, zapewnij, że wykres jest czytelny 


#Zadanie 8. Zrób wykres punktowy pokazujący zależność kosztu od kosztu ratecard per kopia. wykonaj go w motywie mrocznym (dark), a punkty niech będą pomarańczowe


#Zadanie 9. Stwórz histogram GRP z dziesięcioma przedziałami

