#### MMM w praktyce - przetwarzanie danych - rozwiązania zadań  ####
#### Tidyverse 3: joins, lubridate, ggplot ####


#Zadanie 0A. Wczytaj pliki example_TV, example_TV_dict, example_TV_dict2, example_YT.csv, example_OLV.csv
yt.df <- read_csv2("example_YT.csv")
olv.df <- read_csv2("example_OLV.csv")

tv.df <- read_csv2("example_TV.csv")
tv.dict.df <-read_csv2("example_TV_dict.csv")
tv.dict.2.df <- read_csv2("example_TV_dict2.csv")

#Zadanie 1. Połącz dane z YT z danymi OLV tak, aby zachować wszystkie wiersze. Posortuj je po dacie
total.olv.df <- yt.df %>% 
    full_join(olv.df) %>% 
    arrange(Date)

#Zadanie 2. Zasłownikuj dane example_TV słownikiem example_TV_dict
tv.dicted.df <- tv.df %>% 
    left_join(tv.dict.df, by = c("Brand" = "Brand_name"))

#Zadanie 3. Obejrzyj dane example_TV i example_TV_dict2. Zasłownikuj jedne drugimi. 
tv.dicted.2.df <- tv.df %>% 
    left_join(tv.dict.2.df, by = c("Brand" = "Brand_name", "TV_spot" = "TV_spot_description"))


#Zadanie 0B. Wczytaj pliki example_dates1, example_dates_2a, example_dates_2b, example_dates_3
ex.date.1.df <- read_csv2("example_dates1.csv")
ex.date.2a.df <- read_csv2("example_dates2a.csv")
ex.date.2b.df <- read_csv2("example_dates2b.csv")
ex.date.3.df <- read_csv2("example_dates3.csv")

#Zadanie 5. Do danych z example_date1 dołącz kolumnę, która określi datę - zadbaj o to, żeby faktycznie była datą
ex.date.1.df <- ex.date.1.df %>% 
    mutate(Date = paste(Year, Month, Day, sep = "-")) %>% 
    mutate(Date = as_date(Date))

#Zadanie 6. W tabeli example_date3 znajdziesz aktywności z poszczególnych dni. Aktywności są automatycznie raportowane przez system do księgowości ostatniego dnia danego miesiąca. Dodaj kolumnę reporting_date, w której oznaczysz, w którym dniu (data) każda z aktywności zostanie zaraportowana
ex.date.3.df <- ex.date.3.df %>% 
    mutate(reporting_date = ceiling_date(Activity_date, unit = "months") - days(1))

#Zadanie 7. W danych z pliku example_dates_2a Zmień dane dzienne w dane tygodniowe i dołącz do nich plik 2b
ex.date.2a.df <- ex.date.2a.df %>% 
    mutate(week.date = floor_date(Date, unit = "weeks", week_start = 1)) %>% 
    select(-Date) %>% 
    group_by(week.date) %>% 
    summarise(YouTube_views = sum(YouTube_views)) %>% 
    left_join(ex.date.2b.df, by = c("week.date" = "Date"))
    
#Zadanie 0C. Wczytaj pliki example_TV.csv
example.tv.df <- read_csv2("example_TV.csv")

#Zadanie 7. Zrób wykres słupkowy, pokazujący koszt (nie ratecard) per marka, zapewnij, że wykres jest czytelny 
ggplot(example.tv.df) + 
    geom_col(aes(x = Brand, y = COST_PLN)) +
    theme(axis.text.x=element_text(angle=90))

#Zadanie 8. Zrób wykres punktowy pokazujący zależność kosztu od kosztu ratecard per kopia. wykonaj go w motywie mrocznym (dark), a punkty niech będą pomarańczowe
ggplot(example.tv.df) + 
    geom_point(aes(x = COST_RATECARD, y = COST_PLN), color = "orange") + 
    theme_dark()

#Zadanie 9. Stwórz histogram GRP z dziesięcioma przedziałami
ggplot(example.tv.df) + 
    geom_histogram(aes(x = GRP), bins = 10) 




