#### MMM w praktyce - przetwarzanie danych - wyklad  ####
#### Tidyverse: operacje na zmiennych, na kolumnach, Pivoty, Stringr ####
library(dplyr)
library(readr)
library(tidyr)

## Wczytanie danych
tv.df <- read_csv2("example_TV2.csv")


#### Część I: opreacje na zmiennych ####
#### mutate - tworzenie zmiennej za pomoca formuły 

#stworzenie kolumny CPP (czyli koszt/GRP) i CPP_RATECARD (odpowiednio)
#R podpowie tabulację, ale samemu warto jej pilnować
tv.1.df <- tv.df %>% 
    mutate(CPP = COST_PLN / GRP, 
           CPP_RATECARD = COST_RATECARD / GRP)

#mutate'a można skutecznie łączyć z group_by()

#oblicz średnie CPP dla każdej długości kopii
tv.1.df <- tv.1.df %>% 
    group_by(Duration) %>% 
    mutate(Avg_CPP = mean(CPP)) %>% 
    ungroup()

#po co mutate, skoro można to robić w Base'ie? 

#### select wybiera potrzebne nam kolumny

#wybranie tylko kolumn Brand i Cost_PLN
tv.2.df <- tv.df %>% 
    select(Brand, COST_PLN)

#starts_with("X") #every name that starts with "X",
#ends_with("X")  #every name that ends with "X",
#contains("X")  #every name that contains "X",
#matches("X") #every name that matches "X", where "X" can be a regular expression,

#wybranie tylko BRAND, TV_spot i obu CPP z tv.1.df
tv.3.df <- tv.1.df %>% 
    select(Brand, TV_spot, starts_with("CPP"))

#odrzucenie kolumn Ratecardowych z tv.1.df
tv.4.df <- tv.1.df %>% 
    select(-ends_with("RATECARD"))

#selecta można też użyć do przeorganizowania kolumn (choć jest to średnio eleganckie i kłopotliwe przy dużej liczbie kolumn - wówczas lepiej użyć arrange() )
#przestaw GRP na początek
tv.4.df <- tv.4.df %>% 
    select(GRP, everything())

#### rename zmienia nazwy kolumn
# uwaga na składnię! 

#Zmień nazwę Avg_CPP na Average_CPP

tv.4.df <- tv.4.df %>% 
    rename(Average_CPP = Avg_CPP)

#ZADANIE 0 - wczytaj plik example_TV.csv tworząc tv.df 

#ZADANIE 1 - stwórz zmienną "Discount", która pokaże poziom rabatu (rabat = 1 - (COST_PLN/COST_RATECARD))

#ZADANIE 2 - stwórz zmienną "Duration_avg", która pokaże średnią dlugość spotu (Duration) per marka

#ZADANIE 3 - w df-ie stworzonym w zadaniu 1 albo 2 pozostaw tylko kolumnę z nazwą marki oraz nowo stworzoną zmienną. Zrób to używając Pipe'a

#ZADANIE 4 - z oryginalnego df-a usuń kolumny zawierające w nazwie słowo "COST" (podkreślam: zawierające)

#ZADANIE 5 - zmień nazwę "COST_RATECARD" na "RATECARD_COST" 

########## Część II: operacje na wierszach ####

#pracujemy na tych samych danych

# filter - filtruje (dokładniej: pozostawia) tylko wybrane wiersze

# wybierz z naszych danych tylko wiersza zawierające dspoty o długości 15'' lub krótsze
tv.6.df <- tv.df %>% 
    filter(Duration <= 15)

# Albo takie, które zawierają marki Hebe lub Lidl
tv.7.df <- tv.df %>% 
    filter(Brand == "Hebe" | Brand == "Lidl")

# arrange pozwala sortować naszą tabelę
#posortuj spoty po długości spotu a potem po COST_RATECARD 
tv.8.df <- tv.df %>% 
    arrange(Duration, COST_RATECARD)

#ZADANIE 6 - w tv.df pozostaw tylko te spoty, które mają długość 15'' lub 30''

#ZADANIE 7 - posortuj spoty wg CPP (CPP = COST_PLN/GRP)  

#### Część III: Pivotowanie ####

#pivot_longer zmienia dane z formatu szerokiego na długi (albo "dłuższy")
#dawną funkcją jest gather()

#ważne argumenty: 
#cols - które kolumny chcemy transformować - przy okazji zastanów się, co identyfikuje wiersze
#names_to - nazwa kolumny, w której pojawią się dotychczasowe nazwy zmiennych
#values to - nazwa kolumny, w której pojawią się wartości
#names_prefix - możliwość usunięcia wspólnej części nazwy

#wydłuż dane tv.df, pivotując wszystkie kolumny liczbowe do jednej zmiennej
tv.10.df <- tv.df %>% 
    pivot_longer(cols = Duration:COST_RATECARD, 
                 names_to = "data_type", 
                 values_to = "value")

#pivot_wider zmienia dane z formatu długiego na szeroki
#dawną funkcją jest spread()

#ważne argumenty 
#names_from - skąd brać nazwy zmiennych
#values_from - skąd brać wartości zmiennych
#names_prefix - możliwość dodania prefiksu
#values_fill - możliwość wypełnienia NA-ów

#przywróć danym poprzednią formę
tv.11.df <- tv.10.df %>% 
    pivot_wider(names_from = "data_type", 
                values_from = "value")

#ZADANIE 00 - wczytaj plik z danymi pogodowymi (example_data_weather.csv)

#ZADANIE 8 - zmień format danych na długi, obcinając wspólny prefix

#ZADANIE 9 - przelicz dane na Kelwiny (+273,15), zmień format danych z powrotem na szeroki, dodając wspólny prefix z powrotem


#### Część IV: Stringr
library("stringr")

#str_length() - zwraca długość tekstu
#str_c() - skleja teksty (paste?)
#str_replace() - podmienia tekst (sub?)
#str_replace_all() - podmienia wszystkie wystąpienia tektu (gsub?)
#str_detect() - sprawdza, czy dany tekst występuje w innym (grep?)

#ale po co? 

#stwórz trzy stringi (imię, nazwisko, rok urodzenia)
imie <- "Jaromir"
nazwisko <- "Szmitkowski"
rok <- "1981"

#połącz je w jeden string, łączony kropkami, usuń wielkie litery, podmień znaki przestankowe na "XX" i zmierz długość otrzymanego tekstu

dane <- str_c(imie, nazwisko, rok, sep = ".") %>% 
    str_replace("[:upper:]", '') %>% 
    str_replace_all("[:punct:]", 'XX') %>% 
    str_length()

#ZADANIE 10 - w danych TV stworz nową kolumnę Brand_dur, złożoną z Brand i Duration połączonych "_"