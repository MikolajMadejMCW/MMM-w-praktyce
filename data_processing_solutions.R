library(tidyverse)
library(readxl)

data.df <- read_excel("data_processing.xlsx")



#### 1 - modeled variable #### 

# opcja 1
mod.var.1.df <- data.df %>%
    select(Date, starts_with("VO_BEER")) %>%
    mutate(ZM_MOD = rowSums(.[,-1])) %>%                 # wszystkie kolumny oprócz pierwszej (-1)
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
    pivot_longer(names_to = "VO_MOD", c(2:ncol(.))) %>%         # kolumny od 2 do ostatniej. Kropka oznacza aktualnie przetwarzany data frame. ncol(.) jest wiêc liczb¹ 4 (data.frame ma 4 kolumny w momencie puszczenia funkcji ncol(.). 
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


# porównanie
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
    mutate(TYP = substr(variable_name, 1, 3),                                   # dzielimy zmienn¹ variable_name na dwa osobne stringi - od 1 do 3 litery oraz od 4 do ostatniej
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


# liczba obserwacji, któr¹ podajemy do wykresu jako wartoœci osi odciêtych
# nasza kolumna Date nie zawiera wartoœci w kolumnie Daty, tylko wartoœci typu character, st¹d nie mo¿emy podaæ jej jako 
# osi rzêdnych
rows <- nrow(price.shelf.4.df)                                                  

ggplot(price.shelf.4.df, aes(c(1:rows), PR_BEER_SKU1)) +
    geom_line(color="blue") +
    geom_line(aes(c(1:rows), PR_BEER_SKU2), color="red") +
    geom_line(aes(c(1:rows), PR_BEER_SKU3), color="black")




#### longterm price #### 

# poni¿sze rozwi¹zanie manualne mo¿na zaimplementowaæ w postaci uniwersalnej funkcji  by zdobyæ pó³ oceny w górê (slajd 18)
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
    mutate(PS_BEER_SKU1 = (PL_BEER_SKU1 - PR_BEER_SKU1) / (PL_BEER_SKU1)) %>%   # g³êbokoœæ promocji jako odchylenie PR od PL 
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

# funkcja cumprod kroczy od góry kolumny INFLACJA_WOW i ka¿da komórkê nadpisuje iloczynem jej aktualnej wartoœci z wartoœci¹ z komórki powy¿szej
inflation.df <- data.df %>%
    select(Date, INFLACJA_WOW) %>%
    mutate(INFLACJA_BASE = cumprod(INFLACJA_WOW)) %>%
    mutate(INFLACJA_SMOOTH = ((INFLACJA_BASE)     - 1 +              # rêcznie zaimplemetowane wyg³adzenie 5 tygodniowe (wartoœæ w ka¿dym tygodniu jest zast¹piona œredni¹ z 5 najbli¿szychtygodni)
                           lag(INFLACJA_BASE,  1) - 1 +
                           lag(INFLACJA_BASE,  2) - 1 +
                          lead(INFLACJA_BASE,  1) - 1 +
                          lead(INFLACJA_BASE,  2) - 1)  / 5 + 1)

# po obejrzeniu wyników powy¿szego df widzimy, ¿e na pocz¹tku okresu i na koñcu powsta³y wartoœci NA ze wzgledu na u¿ycie funkcji lead() i lag(), które przesuwaj¹ wartoœci z ca³ej kolumny o n okresów
# nadpisujemy powy¿szy df, tym razem podaj¹c argument default, który automatycznie wype³nia NA wartoœci¹
# w tym wypadku NA na pocz¹tku okresu wype³niamy wartoœci¹ 1 - czyli pierwsz¹ dostêpn¹ niebêd¹c¹ NA w kolumnie inflation.df$INFLACJA_SMOOTH
# ostatni¹ wartoœæ inutujemy jako 1.18 - jest to ostatnia wartoœæ niebêd¹ca NA w kolumnie inflation.df$INFLACJA_SMOOTH

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



# rozwi¹zanie alternatywne korzystajace  gotowej funkcji z paczki zoo
inflation.2.df <-  data.df %>%
    select(Date, INFLACJA_WOW) %>%
    mutate(INFLACJA_BASE = cumprod(INFLACJA_WOW)) %>%
    mutate(rolling_mean = zoo::rollmeanr(INFLACJA_BASE, 5, na.pad = TRUE, align = "center"))

