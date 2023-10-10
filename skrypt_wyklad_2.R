### Wyklad nr 2
### 2023-10-10



# 1. Przygotowanie srodowiska ---------------------------------------------

### Wyczyszczenie srodowiska - polecam na poczatku kazdego skryptu 
rm(list = ls())

### Instalacja pakietow
# install.packages("lubridate")

### Wczytanie pakietow
library(lubridate)

### Help - co to za pakiet / funkcja? 
?lubridate
?sum
help(sum)
help(log, package = base)

### Informacja jakie pakiety obecnie mamy zaladowane
### lub: prawy dolny kafelek, zakladka "Packages"
search()


### Petla instalujaca wiekszosc pakietow potrzebnych na przyszlych zajeciach
necessary.packages <- c("car", "data.table", "data.tree", "dygraphs", 
                        "tidyverse", "dplyr", "ggplot2", "lmtest", "lubridate", 
                        "magrittr", "plm", "plotly", "RMark", "sandwich", 
                        "stats", "stringr", "tidyr", "tseries", "xts", "zoo")

for (i in 1:length(necessary.packages)) {
    if (!necessary.packages[i] %in% installed.packages())
        install.packages(necessary.packages[i])
}


# ### Working directory (wd)
# ### Przy korzystaniu z projektow nie uzywamy!
# getwd() # Aktualne working directory
# setwd("C:/users/patryk.kwiatkowski/") # Ustawienie niestandardowej sciezki
# getwd()

### Wczytywanie plikow .csv
example <- read.csv2("ksiazki_raw_data.csv",
                     stringsAsFactors = F)

### Zapisywanie plikow .csv
write.csv2(example,
           "ksiazki_raw_data.csv",
           row.names = F)

### read.csv()
### save() / load()
### pakiet readr (omowiony na nastepnych zajeciach z tidyverse)




# 2. Podstawy -------------------------------------------------------------

### 2 sposoby przypisywania wartosci zmiennych
x = 2.5
y <- 3   # w przypadku R stosowany jest zazwyczaj ten sposob

x + y
z <- sum(x, y)
z

### Usuwanie obiektow: funkcja `rm()` lub `remove()`
rm(x)                 # Usuwanie pojedynczej zmiennej
rm(list = c(y, z))    # Usuwa z Global Env 2 obiekty: y i z
rm(list = ls())       # Usuwa wszystkie obiekty z Global Env


### Typy danych
liczba <- 5.5
text <- 'Ania'
boolean.true <- TRUE
boolean.false <- F
moj.pierwszy.wektor <- c(1, 2, 3, 4, 5)

sample.ls <- list(imiona = c("Anna", "Maria"), 
                  nazwisko = "Kowalska", 
                  wiek = 30, 
                  pracuje_w_MediaCom = TRUE)

macierz.mx <- matrix(1:10, nrow = 2, ncol = 5)

data.df <- data.frame(imie = c('Kasia', 'Gosia', 'Małgosia'), 
                      wiek = c(12, 32, 17))

plec.kategoria <- factor(c('F', 'F', 'M', 'F', 'M', 'M', 'M', 'F'))

data <- as.Date("2021-12-21")

# Sprawdzenie obiektu
str(liczba)
str(text)
str(sample.ls)
str(macierz.mx)
str(data.df)
str(plec.kategoria)
str(data)

is.numeric(liczba)
is.character(liczba)

is.numeric(7.2)
is.integer(7.2)

# Zmiana typu
liczba.tekst <- as.character(liczba)
liczba.tekst
str(liczba.tekst)


### Dzialania na data.frame
data.df

colnames(data.df) #Nazwy kolumn
rownames(data.df) #Nazwy wiersz

rownames(data.df) <- c("Osoba_1", 
                       "Osoba_2",
                       "Osoba_3")
data.df

data.df[2, ] # drugi wiersz z df
data.df[, 2] # druga kolumna z df
data.df[2, 2]
data.df[1:2, 1]

data.df$imie
data.df$wiek


### Sekwencja liczb o podanej dlugosci lub z podanym stepem
seq(1, 10, by = 1)
seq(1, 10, length.out = 91)

### Powtorzenie wartosci / wektoria okreslona ilosc razy
rep(1, times = 100)
rep(c(2, 3, 4),
    length.out = 330)


# Zadanie 1. --------------------------------------------------------------

### a) stworz wektor skladajacy sie ze stu jedynek
### b) Dopisz na jego końcu swoje imie
### c) Jakiego typu jest wektor z a) & b)?
### d) Usuń z wektora b) pierwsza obserwacje
### e) zamien wektor z podpunktu d na macierz o wymiarach 10x10


# 2. Podstawy c.d. --------------------------------------------------------

### Sprawdzenie dlugosci wektora
moj.pierwszy.wektor
length(moj.pierwszy.wektor)

### Dodanie nowego elementu (lub elementow) do wektora
append(moj.pierwszy.wektor, 42)
c(moj.pierwszy.wektor, 42)

### Sprawdzenie czy dwa obiekty sa identyncze
x <- c(7, 8, 9)
y <- c(9, 8, 7)
identical(x, y)
identical(x, rev(y)) # Po odwroceniu kolejnosci w wektorze y oba wektory sa juz identyczne

### Sprawdzenie zakresu elementow
data.df
range(data.df$wiek)

### Sprawdzanie czy co najmniej jedna wartosc spelnia warunek
wektor <- c(1, 2, NA, 4)

is.na(wektor)      # Sprawdza po kolei
any(is.na(wektor)) # Sprawdza czy conajmniej jeden raz spelniony warunek

is.numeric(wektor)
is.numeric(data.df$wiek)
is.numeric(data.df$imie)

### Operatory logiczne (BOOLEAN) np. 
### >
### <
### >=
### <= 
### ==
### !=
### x | y    x OR  y
### x & y    x AND y

2 > 1
2 < 1

2 >= 2

wektor
wektor == 1

data.df
data.df$imie == "Gosia"
data.df$wiek == 12
data.df[data.df$wiek >= 17, ]
data.df[data.df$imie == "Gosia" & data.df$wiek <= 50, ]
data.df[data.df$wiek < 17 | data.df$wiek >= 20, ]


### Sprawdzenie czy elementy jednego wektora zawieraja sie w drugim
najwieksze.miasta.ludnosc <- c("Warszawa", "Kraków", "Łódź", "Wrocław")
najwieksze.miasta.powierzchnia <- c("Warszawa", "Szczecin", "Kraków")

najwieksze.miasta.ludnosc %in% najwieksze.miasta.powierzchnia
najwieksze.miasta.ludnosc[najwieksze.miasta.ludnosc %in% najwieksze.miasta.powierzchnia]


# 3. Data processing ------------------------------------------------------

rm(list = ls())

x <- -9.91
y <- 7

x + y
x * 2
x^2
sqrt(y)

y %% 2   # Reszta z dzielenia
y %/% 2  # Calkowita czesc z dzielenia


log(y)           # logarytm naturalny
log10(y)         # logarytm dziesiętny
log(y, base = 3) # logarytm o wybranej podstawie

exp(y)
abs(x)

round(x, 1)

wektor <- c(1, 2, 3, NA, 5, 6)
min(wektor)
min(wektor, na.rm = T)

max(wektor)
max(wektor, na.rm = T)

sum(wektor)
sum(wektor, na.rm = T)


# 4. Plots ----------------------------------------------------------------

### stworzmy przykladowy data.frame
rm(list = ls())

data.df <- data.frame(ID = c(1:10),
                      Year = c(2017:2026),
                      Variable = rep("Variable_1", 10),
                      Value_1 = sin(rnorm(10)) + 2,
                      Value_2 = c(1:10)^2,
                      Boolean = rgeom(10, 0.5))

### Kolumna `Boolean` stworzona na podstawie rozkladu
### Zrobmy z niej kolumne typu logicznego
data.df$Boolean = ifelse(data.df$Boolean == 1, T, F)
str(data.df)

### Ustawienie reproduktywnosci wynikow
set.seed(998)

### Suma w kolumnie
colSums(data.df[, 4:5])
colSums(is.na(data.df))  # Sprawdzenie czy nie ma zadnych NA w dataframe


### Plot - do szybkiego checku
plot(data.df$Value_2)
plot(data.df$Value_2, type = 'l')

plot(data.df$Value_2 ~ data.df$Year,
     type = 'l')

### Zrobmy super wykres
plot(x = data.df$Year,
     y = data.df$Value_1,
     type = 'l',
     lwd  = 2,
     main = "Procentowy wzrost sprzedazy w latach 2018-2026",
     xlab = "Lata",
     ylab = "% zmiany sprzedazy",
     ylim = c(0, max(data.df$Value_1)),
     las  = 1)

### Dodajmy serie ze zmiana sprzedazy konkurencji
lines(x = data.df$Year,
      y = sin(rnorm(10)) + 1,
      col = 'red',
      las = 1)

### Dodajmy legende w wybranym miejscu
legend("bottomright",
       c("Firma 1", "Firma 2"),
       fill = c('black', 'red'))

### Co jezeli chcemy narysowac 2 ploty kolo siebie?
par(mfrow = c(1, 2))     # ustawiamy analogicznie jak w df: pierwsza liczba to wiersze, druga to kolumny
plot(data.df$Value_1)
plot(data.df$Value_2)
dev.off()                # Wylaczenie mfrow(), ewentualnie mozna ustawic mfrow = c(1,1)
plot(data.df$Boolean)    # Wracamy do Widoku z tylko jednym wykresem



### Inne przydatne rodzaje plotow
### Histogram
hist(data.df$Value_2)
hist(rnorm(1000))
hist(as.numeric(data.df$Boolean))

hist(rnorm(1000), freq = F,   las = T)
lines(density(rnorm(1000)))

hist(rnorm(1000), breaks = 4, las = T)


### Barplot
barplot(height = data.df$Value_1,
        names  = data.df$Year)


### Box plot
### Mediana, outliery, wasy to dlugosc poltorej wartosci rozstepu cwiartkowego (Q3 - Q1)
boxplot(rnorm(100),
        horizontal = T)

boxplot(rnorm(100),
        rnorm(100),
        horizontal = T)



### Zadanie 2. -------------------------------------------------------------
### Wczytaj przeslana .csv
### Zrob wykres liniowy pokazujacy sprzedaz ksiazek w Polsce w kolejnych latach
### Powinien on wygladac tak jak ten ze slajdu

### TIP: read.csv2()


# 5. Conditionals ---------------------------------------------------------

### Petla if... (najprostsza)
if (warunek1) {
    instrukcja       # jezeli warunek1 jest spelniony wykonuje sie instrukcja
}


### Petla if... else...
if (warunek1) {
    instrukcja1
} else {
    instrukcja2      # jezeli warunek1 nie jest spelniony wykonuje sie instrukcja2
}


### Petla if...else if...else
if (warunek1) {
    instrukcja1            # Jezeli jest spelniony warunek1
} else if (warunek2) {
    instrukcja2            # Jezeli nie spelnil sie warunek1 i spelnil sie warunek2
} else {
    instrukcja3            # Jezeli nie spelnil sie zaden z warunkow
}


### Przyklady
### 1. Sprawdzenie czy wartosci w wektorze sa identyczne
vec <- c(9, 9, 9)
if (vec[1] == vec[2] & vec[2] == vec[3]) {
    print("Identyczne")
} else {
    print("Rozne")
}

### 2. Czy liczba x jest dodatnia / ujemna
x <- 7
if (x > 0) {
    print("x jest liczba dodatnia")
} else if (x == 0) {
    print("x ma wartosc 0")
} else {
    print("x jest liczba ujemna")
}

### 3. Czy co najmniej jedna z liczb jest większa od 10 lub czy obydwie są większe od 10?
liczba1 <- 9
liczba2 <- 9

if (liczba1 > 10 & liczba2 > 10) {
    print("Obydwie liczby są większe od 10")
} else if (liczba1 > 10|liczba2 > 10) {
    print("Co najmniej jedna z liczb jest większa od 10")
} else {
    print("Żadna z liczb nie jest większa od 10")
}

### 4. Niepoprawnie napisany if
Plec <- "Niezdefiniowana"

if (Plec == "Kobieta") {
    print("Plec zenska")
} else {
    print("Plec meska")
}


### Zadanie 3. --------------------------------------------------------------
### Wylosuj dwie zmienne: cenę netto produktu z przedziału [5,20] (nie musi być całkowita) 
### oraz typ klienta (prywatny lub firmowy). Wydrukuj w konsoli finalną cenę produktu, 
### wiedząc, że przy cenie netto powyżej 10 zł przysługuje dodatkowy rabat 10% 
### oraz że klienci firmowi nie płacą VAT-u (prywatni tak).

### TIP: Przydatne moga byc funkcje `runif` i `sample()` - przeczytaj help do nich



# 6. Loops ----------------------------------------------------------------

### Najprostsza petla
for (i in 1:5) {
    print(i)
}

### Przyklad petli na data.frame
data.df

for(i in 1:nrow(data.df)) {
    Rok <- data.df$Year[i]
    Val <- data.df[i, 5]

    output <- paste0("Iteracja nr ", i, ". Dla roku ", Rok, " wartosc wynosi: ", Val)
    print(output)
}


### Petle mozna pisac na rozne sposoby
wyniki.egzaminu <- c(100, 150, 70, 90, 40)

for (i in 1:length(wyniki.egzaminu)) {
    print(paste("Osoba", 
                i, 
                "uzyskała wynik:", 
                wyniki.egzaminu[i], sep = " "))
}

# jak widzimy, w R iteratorem niekoniecznie muszą być liczby!
for (wynik in wyniki.egzaminu) {
    print(paste("Osoba", 
                which(wyniki.egzaminu == wynik), 
                "uzyskała wynik:", 
                wynik, 
                sep = " "))
}


### Zagniezdzanie petli for
liczby <- c(1:3)
potegi <- c(4:6)

for (i in 1:length(liczby)) {
    for (j in 1:length(potegi)) {
        print(paste("Liczba", 
                    liczby[i], 
                    "podniesiona do potegi", 
                    potegi[j], 
                    "wynosi", 
                    liczby[i]^potegi[j], 
                    sep = " "))
    }
}


### Dodatkowe instrukcje przy petlach
x = 1:5
for (i in x) { 
    if (i == 4) { 
        break    # Petla przerwie sie przy 4tej iteracji
    }
    print(i)
}

for (i in x) { 
    if (i == 4) { 
        next    # Petla pominie 4ta iteracje
    }
    print(i)
}


### !!! Ponizszych 2 petli raczej nie polecam uzywac w ogole

### Petla while
liczba.obserwacji <- 1
while (liczba.obserwacji < 10) {
    print(paste("Wciąż za mało obserwacji. Tylko:", liczba.obserwacji, sep = " "))
    liczba.obserwacji <- liczba.obserwacji + 1
} 

### Petla repeat
liczba.obserwacji <- 1
repeat {
    print(paste("Wciąż za mało obserwacji. Tylko:", liczba.obserwacji, sep = " "))
    liczba.obserwacji <- liczba.obserwacji + 1
    if (liczba.obserwacji == 10) {
        break
    }
}



# Zadanie 4. --------------------------------------------------------------

### a) Wygeneruj wektor abc jako dowolna sekwencje 50 liczb
### b) Stworz zmienna z wylosowana dowolna liczba N z zakresu 1:50
### c) Za pomoca petli stworz wektor abc.do.kwadratu, ktory bedzie 
###    zawieral N pierwszych liczb wektora abc podniesionych do kwadratu
### d) W konsoli pojawi sie odpowiednio N komunikatow "Kwadratem liczby ... jest liczba ..."


# Zadanie 5. --------------------------------------------------------------

### Napisz petle, ktora na podstawie wektora A (sekwencja liczb 1:100) stworzy wektor X, taki ze:
### x[1] = a[1]
### x[2] = a[1] + a[2]
### x[3] = a[1] + a[2] + a[3]
### ....