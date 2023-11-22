library(tidyverse)
library(readxl)
library(lubridate)

    
# zad 1) Wczytaj dane covidowe (covid_google_mobility_data.csv)
#        W osobnej ramce wybierz zmienna date i zmienna Mobility index dla retailu (kolumna retail_and_recreation_percent_change_from_baseline),
#        nazwij ja MOBILITY_RETAIL
#        Zamien czestotliwosc dzienna na tygodniowa, liczac srednia z 7 dni dla kazdego tygodnia

---------------------------------------------------------------
    
# 
# zad 2) Zestaw zmienne mobility index retail i residential (w czestotliwosci dziennej) na wykresie liniowym
#        Zadbaj o to, by wykres byl czytelny
    
---------------------------------------------------------------

# 
# zad 3) Stworz data frame ze zmienna Date, 
#        ktora przyjmuje wartosci tygodniowe dat od 2021-01-04 do 2022-05-23.
#        Mozesz zastosowac funkcje seq()

---------------------------------------------------------------
    
# 
# zad 4) Stworz 3 zmienne w okresie podanym w zadaniu 2:
#        a) XMAS, ktora przyjmuje wartosc 1 dla 25 grudnia kazdego roku
#        b) EASTER, ktora przyjmuje wartosci 1 dla Niedzieli Wielkanocnej w kazdym roku
#        c) Y2022, ktora przyjmuje wartosci 1 dla wszystkich dat w 2022 roku
    
---------------------------------------------------------------
    
# 
# zad 5) Wczytaj dane sales_data.xlsx
#        Na podstawie zmiennej INFLACJA_WOW (wspolczynnik inflacji tydzien vs poprzedni tydzien) przygotuj zmienne:
#        a) INFLACJA_BASE - skumulowany wspolczynnik inflacji w odniesieniu do pierwszego tygodnia
#        c) INFLACJA_SMOOTH - scentrowana srednia ruchoma z 5 tygodni policzona na podstawie zmiennej INFLACJA_BASE
    
--------------------------------------------------------------- 
    
    

    