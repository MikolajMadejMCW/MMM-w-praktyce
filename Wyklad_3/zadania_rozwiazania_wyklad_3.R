zad.1.df <- read_csv2("example_data_DFS.csv")

zad.2.df <- read_excel("example_data_DFS.xlsx",
                       sheet = 2,
                       skip =  2)

zad.3.df <- read_excel("example_data_DFS.xlsx",
                       sheet = 2,
                       range = cell_rows(3:5))

zad.4.df <- read_csv2("example_data_DFS.csv",
                      col_types = cols(.default = "c"))

zad.5.df <- zad.1.df %>%
    separate(variable_name,
             into = c("Medium", "Rok", "Nazwa"))

zad.6.df <- zad.1.df %>%
    separate(variable_name,
             into = c("Medium", "Rok", "Nazwa")) %>%
    unite(col = "final_variable",
          c("Medium", "Campaign"),
          sep = " ")

zad.7.df <- TV.df %>%
    group_by(Duration) %>%
    summarise(PLN_sum = sum(COST_PLN))  %>%
    ungroup()

zad.8.df <- TV.df %>%
    group_by(Brand, Duration) %>%
    summarise(PLN = min(COST_PLN))  %>%
    ungroup()

zad.9.df <- read_csv2("example_data_weather.csv") %>%
    select(-Date) %>%
    summarise_all(funs(min))

zad.10.df <- read_csv2("example_YT.csv") %>%
    group_by(Date = cut(Date, "weeks")) %>%
    summarise_all(funs(sum)) %>%
    ungroup()

sum(zad.10.df$YouTube_views) == sum(read_csv2("example_YT.csv")$YouTube_views)





























zad.11.df <- read_csv2("example_dirty_data.csv") %>%
    mutate(YouTube_views_clean = str_replace_all(YouTube_views, " ", "")) %>%
    mutate(YouTube_views_clean = as.numeric(YouTube_views_clean))
