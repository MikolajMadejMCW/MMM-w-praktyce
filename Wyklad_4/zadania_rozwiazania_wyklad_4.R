#ZADANIE 0 - wczytaj plik example_TV.csv tworząc tv.df 
tv.df <- tv.df <- read_csv2("example_TV.csv")

#ZADANIE 1 - stwórz zmienną "Discount", która pokaże poziom rabatu (rabat = 1 - (COST_PLN/COST_RATECARD))
tv.df <- tv.df %>% 
    mutate(Discount =  1 - (COST_PLN/COST_RATECARD))

#ZADANIE 2 - stwórz zmienną "Duration_avg", która pokaże średnią dlugość spotu (Duration) per marka
tv.df <- tv.df %>% 
    group_by(Brand) %>% 
    mutate(Duration_avg = mean(Duration)) %>% 
    ungroup()

#ZADANIE 3 - w df-ie stworzonym w zadaniu 1 albo 2 pozostaw tylko nazwę marki oraz nowo stworzoną zmienną. Zrób to używając Pipe'a

tv.df <- tv.df %>% 
    select(Brand, Discount)

#ZADANIE 4 - z oryginalnego df-a usuń kolumny zawierające w nazwie słowo "COST" (podkreślam: zawierające)
tv.df <- read_csv2("example_TV.csv")

tv.df <- tv.df %>% 
    select(-contains("COST"))

#ZADANIE 5 - w oryginalnym df-ie zmień nazwę "COST_RATECARD" na "RATECARD_COST" 
tv.df <- read_csv2("example_TV.csv")

tv.df <- tv.df %>% 
    rename(RATECARD_COST = COST_RATECARD)

#ZADANIE 6 - w tv.df pozostaw tylko te spoty, które mają długość 15'' lub 30''
tv.df <- read_csv2("example_TV.csv")

tv.df <- tv.df %>% 
    filter(Duration == 15 | Duration == 30)

#ZADANIE 7 - posortuj spoty wg CPP (CPP = COST_PLN/GRP) 
tv.df <- read_csv2("example_TV.csv")

tv.df <- tv.df %>% 
    mutate(CPP = COST_PLN/GRP) %>% 
    arrange(CPP)

#ZADANIE 00 - wczytaj plik z danymi pogodowymi (example_data_weather.csv)
weather.df <- read_csv2("example_data_weather.csv")

#ZADANIE 8 - zmień format danych na długi, obcinając wspólny prefix
weather.df <- weather.df %>% 
    pivot_longer(cols = SE_TEMP_MAX:SE_TEMP_MIN, 
                 names_to = "type", 
                 values_to = "temperature", 
                 names_prefix = "SE_TEMP_") 

#ZADANIE 9 - przelicz dane na Kelwiny (+273,15), zmień format danych z powrotem na szeroki, dodając wspólny prefix z powrotem
weather.df <- weather.df %>% 
    mutate(temperature = temperature + 273.15) %>% 
    pivot_wider(names_from = "type", 
                values_from = "temperature", 
                names_prefix = "SE_TEMPK_")



tv.df <- tv.df %>% 
    mutate(Brand_dur = str_c(Brand, Duration, sep = "_"))