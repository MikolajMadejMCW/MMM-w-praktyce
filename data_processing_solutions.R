library(tidyverse)
library(readxl)

data.df <- read_excel("data_processing.xlsx")



#### 1 - modeled variable #### 

# opcja 1
mod.var.1.df <- data.df %>%
    select(Date, starts_with("VO_BEER")) %>%
    mutate(ZM_MOD = rowSums(.[,-1])) %>%                 # wszystkie kolumny opr?cz pierwszej (-1)
    mutate(ZM_MOD = log(ZM_MOD)) %>%
    select(Date, ZM_MOD)

# opcja 2
mod.var.2.df <- data.df %>% 
    rowwise() %>% 
    mutate(ZM_MOD = log(sum(across(starts_with('VO_'))))) %>%
    ungroup() %>%
    select(Date, ZM_MOD)

# opcja 3
mod.var.3.df <- data.df %>% 
    select(Date, starts_with("VO_")) %>%
    pivot_longer(names_to = "VO_MOD", c(2:ncol(.))) %>%         # kolumny od 2 do ostatniej. Kropka oznacza aktualnie przetwarzany data frame. ncol(.) jest wi?c liczb? 4 (data.frame ma 4 kolumny w momencie puszczenia funkcji ncol(.). 
    select(-VO_MOD) %>%
    group_by(Date) %>%
    summarise_all(funs(sum)) %>%
    ungroup() %>%
    rename(ZM_MOD = value) %>%
    mutate(ZM_MOD = log(ZM_MOD))


# opcja 4
mod.var.4.df <- data.df %>% 
    select(Date)

mod.var.4.df$ZM_MOD <- log(data.df$VO_BEER_SKU1 + data.df$VO_BEER_SKU2 + data.df$VO_BEER_SKU3)


# por?wnanie
sum(mod.var.1.df$ZM_MOD)
sum(mod.var.2.df$ZM_MOD)
sum(mod.var.3.df$ZM_MOD)
sum(mod.var.4.df$ZM_MOD)


ggplot(mod.var.1.df, aes(c(1:nrow(mod.var.1.df)), ZM_MOD)) +
    geom_line(color="blue") 



#### 2 - shelf price #### 

price.shelf.1.df <- data.df %>%
    select(Date, starts_with("VO_BEER_SKU"), starts_with("VA_BEER_SKU")) %>%
    pivot_longer(names_to = "variable_name", c(2:ncol(.)))
    
price.shelf.2.df <- price.shelf.1.df %>%
    mutate(TYP = substr(variable_name, 1, 3),                                   # dzielimy zmienn? variable_name na dwa osobne stringi - od 1 do 3 litery oraz od 4 do ostatniej
           SKU = substr(variable_name, 4, nchar(variable_name))) %>%
    select(-variable_name) %>%
    pivot_wider(names_from = "TYP", values_from = "value")

price.shelf.3.df <- price.shelf.2.df %>%
    mutate(PR_ = VA_ / VO_)

price.shelf.4.df <- price.shelf.3.df %>%
    pivot_longer(names_to = "variable_name", c(3:ncol(.))) %>%
    mutate(variable_name = paste(variable_name, SKU, sep = "")) %>%
    select(-SKU) %>%
    pivot_wider(names_from = "variable_name", values_from = "value")


# liczba obserwacji, kt?r? podajemy do wykresu jako warto?ci osi odci?tych
# nasza kolumna Date nie zawiera warto?ci w kolumnie Daty, tylko warto?ci typu character, st?d nie mo?emy poda? jej jako 
# osi rz?dnych
rows <- nrow(price.shelf.4.df)                                                  

ggplot(price.shelf.4.df, aes(c(1:rows), PR_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PR_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PR_BEER_SKU3), color="black")




#### longterm price #### 

# poni?sze rozwi?zanie manualne mo?na zaimplementowa? w postaci uniwersalnej funkcji  by zdoby? p?? oceny w g?r? (slajd 18)
price.df <- price.shelf.4.df %>%
    select(Date, starts_with("PR"))

apply(price.df[,2:(ncol(price.df))], 2, median)
table(price.df$PR_BEER_SKU2)

price.longterm.df <- price.df %>%
    mutate(PL_BEER_SKU1 = 120,
           PL_BEER_SKU3 = 100,
           PL_BEER_SKU2 = c(rep(130, 56), rep(150, rows - 56))) %>%
    select(Date, starts_with("PL"))

ggplot(price.longterm.df, aes(c(1:rows), PL_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PL_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PL_BEER_SKU3), color="black")




#### 3 - shorterm price #### 

price.shortterm.df <- price.shelf.4.df %>%
    left_join(price.longterm.df) %>%
    select(Date, starts_with("PR"), starts_with("PL")) %>%
    mutate(PS_BEER_SKU1 = (PL_BEER_SKU1 - PR_BEER_SKU1) / (PL_BEER_SKU1)) %>%   # g??boko?? promocji jako odchylenie PR od PL 
    mutate(PS_BEER_SKU2 = (PL_BEER_SKU2 - PR_BEER_SKU2) / (PL_BEER_SKU2)) %>%
    mutate(PS_BEER_SKU3 = (PL_BEER_SKU3 - PR_BEER_SKU3) / (PL_BEER_SKU3)) %>%
    select(Date, starts_with("PS"))

ggplot(price.shortterm.df, aes(c(1:rows), PS_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PS_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PS_BEER_SKU3), color="black")



#### 4 - distribution #### 

distribution.df <- data.df %>%
    select(Date, starts_with("DW_BEER")) %>%
    mutate(DW_BEER = pmax(DW_BEER_SKU1, DW_BEER_SKU2, DW_BEER_SKU3)) %>%
    select(Date, DW_BEER)



#### 5 - inflation #### 

# funkcja cumprod kroczy od g?ry kolumny INFLACJA_WOW i ka?da kom?rk? nadpisuje iloczynem jej aktualnej warto?ci z warto?ci? z kom?rki powy?szej
inflation.df <- data.df %>%
    select(Date, INFLACJA_WOW) %>%
    mutate(INFLACJA_BASE = cumprod(INFLACJA_WOW)) %>%
    mutate(INFLACJA_SMOOTH = ((INFLACJA_BASE)     - 1 +              # r?cznie zaimplemetowane wyg?adzenie 5 tygodniowe (warto?? w ka?dym tygodniu jest zast?piona ?redni? z 5 najbli?szychtygodni)
                           lag(INFLACJA_BASE,  1) - 1 +
                           lag(INFLACJA_BASE,  2) - 1 +
                          lead(INFLACJA_BASE,  1) - 1 +
                          lead(INFLACJA_BASE,  2) - 1)  / 5 + 1)

# po obejrzeniu wynik?w powy?szego df widzimy, ?e na pocz?tku okresu i na ko?cu powsta?y warto?ci NA ze wzgledu na u?ycie funkcji lead() i lag(), kt?re przesuwaj? warto?ci z ca?ej kolumny o n okres?w
# nadpisujemy powy?szy df, tym razem podaj?c argument default, kt?ry automatycznie wype?nia NA warto?ci?
# w tym wypadku NA na pocz?tku okresu wype?niamy warto?ci? 1 - czyli pierwsz? dost?pn? nieb?d?c? NA w kolumnie inflation.df$INFLACJA_SMOOTH
# ostatni? warto?? inutujemy jako 1.18 - jest to ostatnia warto?? nieb?d?ca NA w kolumnie inflation.df$INFLACJA_SMOOTH

inflation.final.df <- data.df %>%
    select(Date, INFLACJA_WOW) %>%
    mutate(INFLACJA_BASE = cumprod(INFLACJA_WOW)) %>%
    mutate(INFLACJA_SMOOTH = ((INFLACJA_BASE)                     - 1 +
                           lag(INFLACJA_BASE,  1, default = 1.00) - 1 +
                           lag(INFLACJA_BASE,  2, default = 1.00) - 1 +
                          lead(INFLACJA_BASE,  1, default = 1.18) - 1 +
                          lead(INFLACJA_BASE,  2, default = 1.18) - 1)  / 5 + 1) 



ggplot(inflation.final.df, aes(c(1:rows), INFLACJA_WOW)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), INFLACJA_BASE), color="red") +
    geom_line(aes(c(1:rows), INFLACJA_SMOOTH), color="black")



# rozwi?zanie alternatywne korzystajace  gotowej funkcji z paczki zoo
inflation.2.df <-  data.df %>%
    select(Date, INFLACJA_WOW) %>%
    mutate(INFLACJA_BASE = cumprod(INFLACJA_WOW)) %>%
    mutate(rolling_mean = zoo::rollmeanr(INFLACJA_BASE, 5, na.pad = TRUE, align = "center"))

