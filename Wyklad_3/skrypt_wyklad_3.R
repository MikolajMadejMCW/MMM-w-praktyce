#### MMM w praktyce - przetwarzanie danych - wyklad 3 ####
#### tidyverse, pipelines, readr, parsing, grouping, summarising ####

library(tidyverse)

#### reading and writing #### -----------------------------------------------------------------------------------------
# https://readr.tidyverse.org/

# reading csv
data.1.1.df <- read.csv2("example_data.csv") # base
class(data.1.1.df)

data.1.2.df <- read_csv2("example_data.csv") # tidyverse for semicolon separated files
class(data.1.2.df)

data.1.3.df <- read_csv("example_data.csv") # tidyverse for comma separated files
class(data.1.3.df)


# writing csv
write.csv2(data.1.1.df, "example_write_base.csv")              # base
write_csv2(data.1.1.df, "example_write_tidyverse2.csv")        # semicolon - dla klasycznych ustawien europejskich excela
write_csv(data.1.1.df,  "example_write_tidyverse.csv")         # comma


# reading excel
# install.packages("readxl")
library(readxl)

data.readxl.raw.1.df <- read_excel(path = "example_data.xlsx")
data.readxl.raw.2.df <- read_excel(path  = "example_data.xlsx",
                                   sheet = 2,                                     # also it could be: sheet = "sheet_name"
                                   skip  = 3)                                     # skips first three rows
head(data.readxl.raw.2.df)



data.readxl.raw.3.df <- read_excel(path  = "example_data.xlsx",
                                   sheet = "example_data",
                                   range = "A4:F5022")          
head(data.readxl.raw.3.df)



data.readxl.raw.4.df <- read_excel(path  = "example_data.xlsx",
                                   sheet = "example_data",
                                   skip  = 3,                                       # Skip not ignored - because it is first in line
                                   range = cell_cols("E:F"),
                                   na    = "TRP")                                   # If we want to replace values with NA
head(data.readxl.raw.4.df)



# writing excel
write_excel_csv2(data.readxl.raw.4.df, "example_write_xlsx.xls")


# saving the whole environment 
save.image("env.RData")
rm(list = ls())

# reading the whole environment
load("env.RData")


# saving and reading selected objects 
save(data.readxl.raw.4.df, 
     data.1.3.df,
     file = "selected_env.RData")

rm(list = ls())
load("selected_env.RData")


load("env.RData")



# ZADANIE 1 - poprawnie wczytaj plik example_data_DFS.csv, nazwij obiekt zad.1.df

# ZADANIE 2 - poprawnie wczytaj plik example_data_DFS.xlsx, nazwij obiekt zad.2.df

# ZADANIE 3 - z pliku example_data_DFS.xlsx wczytaj jedynie wiersze 3, 4, 5. Nazwij obiekt zad.3.df

# ZADANIE 4 - poprawnie wczytaj plik example_data_DFS.csv, automatycznie zmien typ wszystkich kolumn na character, nazwij obiekt zad.4.df 




#### pipelines and parsing #### --------------------------------------------------------------------------------------------

# separate used to correct bad data read
data.1.3.clean.df <- data.1.3.df %>%
    separate(`Date;Brand;Film.Code;Ratecard.Duration;Metric;Value`,
             into = c("Date", "Brand", "Film.Code", "Ratecard.Duration", "Metric", "Value"),
             sep = ";")

# separate used to get days and months from date
separated.df <- data.readxl.raw.2.df %>%
    separate(Date, 
             into = c("Year", "Month", "Day"),
             sep = "-")

# unite
united.df <- separated.df %>%
    unite(col = "Date",
          c("Year", "Month", "Day"),
          sep = ".")




# ZADANIE 5 - sparsuj kolumnę variable name z ramki danych zad.1.df na medium, rok i nazwę, nazwij output zad.5.df

# ZADANIE 6 - kontynuując pipeline z zadania 5 stwórz nową kolumnę zawierającą informację o medium oraz pełną nazwę kampanii


#### grouping and summarising #### -----------------------------------------------------------------------------------------

rm(list = ls())
TV.df <- read_csv2("example_TV.csv") %>%
    select(-TV_spot)

# group_by() and ungroup()
# summarise()

# summarise_all() affects every variable except for groupping variables
# summarise_at() affects variables selected with a character vector or vars()
# summarise_if() affects variables selected with a predicate function

# Center: mean(), median()
# Spread: sd(), IQR(), mad()
# Range: min(), max(),
# Position: first(), last(), nth(),
# Count: n(), n_distinct()
# Logical: any(), all()
# Math: prod() - iloczyn


# ile spotów wyemitowala każda firma?
spot.number.1.df <- TV.df %>%
    group_by(Brand) %>%
    summarise(spot_number = n()) %>%
    ungroup()

# grupowanie wpływa również na pozostałe "czasowniki" tidyverse, takie jak mutate(), które beda przedstawione
# na kolejnych zajeciach. Dzialania beda wtedy wykonane dla kazdej grupy osobno. By uniknąć nieproawidlowosci, dobra praktyką 
# jest wiec uzycie ungroup() zawsze po zakonczeniu summarise.


# SUMMARISE
# ile roznych dlugosci kopii wykorzystuje kazda firma?
spot.number.2.df <- TV.df %>%
    group_by(Brand) %>%
    summarise(spot_number = n_distinct(Duration)) %>%
    ungroup()

# jaki byl najdluzszy spot wyemitowany przez kazda firme?
spot.length.df <- TV.df %>%
    group_by(Brand) %>%
    summarise(max_length = max(Duration)) %>%
    ungroup()

# wypiszmy sobie kilka staytsyk dla kosztu poniesionego prze zkażdą firmę
spend.stats.df <- TV.df %>%
    group_by(Brand) %>%
    summarise(min = min(COST_PLN),
              max = max(COST_PLN),
              sd  = sd(COST_PLN),
              count = n()) %>%
    ungroup()


# SUMMARISE_ALL
# sumowanie "wszystkich kolumn" wymaga usuniecia wszystkich kolumn oprócz grupowanych i sumowanych


# suma wszystkich kolumn z pojednynczym grupowaniem i pojednyncza funkcja
single.group.1.df <- TV.df %>%
    select(-Duration) %>%
    group_by(Brand) %>%
    summarise_all(list(suma = sum)) %>%
    ungroup()

# suma wszystkich kolumn z pojednynczym grupowaniem i podwojna funkcja
single.group.2.df <- TV.df %>%
    select(-Duration) %>%
    group_by(Brand) %>%
    summarise_all(list(suma = sum, mediana = median)) %>%
    ungroup()

# suma wszystkich kolumn z podwojnym grupowaniem i pojednyncza funkcja
double.group.1.df <- TV.df %>%
    group_by(Brand, Duration) %>%
    summarise_all(list(suma = sum)) %>%
    ungroup()

# suma wszystkich kolumn z podwojnym grupowaniem i potrojna funkcja
double.group.2.df <- TV.df %>%
    group_by(Brand, Duration) %>%
    summarise_all(list(suma = sum, mediana = median)) %>%
    ungroup()

# agregowanie kolumn in place, czyli bez zmiany nazwy kolumn
in.place.df <- TV.df %>%
    select(-Duration) %>%
    group_by(Brand) %>%
    summarise_all(funs(sum)) %>%
    ungroup()




# SUMMARISE_AT również może zostac użyty do grupowania "in place" a na dodatek bezpośrednio wspiera nazwy kolumn w formie stringów
summarise.at.df <- TV.df %>%
    group_by(Brand) %>%
    summarise_at(c("GRP", "COST_PLN"), mean) %>%
    ungroup()

# SUMMARISE_IF
summarise.if.1.df <- TV.df %>%
    group_by(Brand) %>%
    summarise_if(is.numeric, mean) %>%
    ungroup()




# ZADANIE 7 - na jaka dlugosc kopii rynek kosmetyczny wydaje najwiecej pieniedzy?

# ZADANIE 8 - która firma wyemitowała najtanszy spot? Jakiej był on odlugości?

# ZADANIE 9  - wczytaj plik example_data_weather.csv, sprawdź najniższą temperturę minimalna, maksymalna i srednia, jaka zostala zanotowana
# dokonaj obliczen "in place"

# ZADANIE 10 - wczytaj plik example_YT.csv, zagreguj dzienne dane do tygodniowych, gdzie daty tygodniowe są datą poniedziałku
# zagadnienie nie zostało przedstawione na zajeciach - zadanie dodatkowe


