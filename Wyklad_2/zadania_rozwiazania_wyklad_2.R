rm(list = ls())

# Zadanie 1 ---------------------------------------------------------------

### a) stworz wektor skladajacy sie ze stu jedynek
### b) Dopisz na jego końcu swoje imie
### c) Jakiego typu jest wektor z a) & b)?
### d) Usuń z wektora b) pierwsza obserwacje
### e) zamien wektor z podpunktu d na macierz o wymiarach 10x10

# a)
v.a <- rep(1, 100)

# b)
v.b <- c(v.a, 'Zenon')

# c)
str(v.a)
str(v.b)

# d)
v.d <- v.b[-1]

# e)
matrix(v.d, ncol = 10, nrow = 10)



# Zadanie 2 ---------------------------------------------------------------

### Wczytaj przeslana .csv
### Zrob wykres liniowy pokazujacy sprzedaz ksiazek w Polsce w kolejnych latach
### Powinien on wygladac tak jak ten ze slajdu
rm(list = ls())

obroty.na.rynku.ksiazki.df <- read.csv2("ksiazki_raw_data.csv",
                                        stringsAsFactors = F)

# obroty.na.rynku.ksiazki.df <- data.frame(Lata = c(1995:2014),
#                                          Księgarnie_indywidualne = c(45,44,44,42,34,34,29,26,24,24,
#                                                                      21,19,17,17,17,15,13,12,11,8),
#                                          Sieci_księgarskie = c(2,3,4,5,6,7,8,9,11,12,13,
#                                                                16,18,19,20,23,24,26,27,28),
#                                          Domy_Książki = c(14,12,11,9,8,7,6,6,6,
#                                                           6,5,5,4,4,3,3,3,2,2,2),
#                                          Inne_kanały_dystrybucji = c(39,41,41,44,49,52,57,59,59,
#                                                                      58,61,60,61,60,60,59,60,60,61,62))

obroty.na.rynku.ksiazki.df <- obroty.na.rynku.ksiazki.df[obroty.na.rynku.ksiazki.df$Kraj == "Polska", ]


plot(x = obroty.na.rynku.ksiazki.df$Lata, 
     y = obroty.na.rynku.ksiazki.df$`Księgarnie_indywidualne`, 
     type = "l", 
     ylim = c(0,100), 
     col = "blue", 
     main = "Dystrybucja na rynku ksiazki", 
     xlab = "Czas", 
     ylab = "Sprzedaż w różnych kanałach dystrybucji [%]")
lines(x = obroty.na.rynku.ksiazki.df$Lata, 
      y = obroty.na.rynku.ksiazki.df$`Inne_kanały_dystrybucji`, 
      col = "green")
lines(x = obroty.na.rynku.ksiazki.df$Lata, 
      y = obroty.na.rynku.ksiazki.df$`Sieci_księgarskie`, 
      col = "purple")
lines(x = obroty.na.rynku.ksiazki.df$Lata, 
      y = obroty.na.rynku.ksiazki.df$`Domy_Książki`, 
      col = "red")
legend("topright", 
       c("Ksiegarnie indywiduale", "Inne kanaly", "Sieci ksiegarskie", "Domy ksiazki"), 
       lty = c(1,1), 
       cex = 0.7, 
       col = c("blue", "green", "purple", "red"))


# Zadanie 3 ---------------------------------------------------------------

### Wylosuj dwie zmienne: cenę netto produktu z przedziału [5,20] (nie musi być całkowita) 
### oraz typ klienta (prywatny lub firmowy). Wydrukuj w konsoli finalną cenę produktu, 
### wiedząc, że przy cenie netto powyżej 10 zł przysługuje dodatkowy rabat 10% 
### oraz że klienci firmowi nie płacą VAT-u (prywatni tak).
rm(list = ls())

cena.netto <- runif(1, 5, 20)
typ.klienta <- c("Prywatny", "Firmowy")[sample(1:2, 1)]


if (cena.netto > 10 & typ.klienta == "Prywatny") {
    (cena.finalna <- cena.netto * 0.9 * 1.23)
} else if (cena.netto > 10 & typ.klienta == "Firmowy") {
    (cena.finalna <- cena.netto * 0.9)
} else if (cena.netto <= 10 & typ.klienta == "Prywatny") {
    (cena.finalna = cena.netto * 1.23)
} else if (cena.netto <= 10 & typ.klienta == "Firmowy") {
    (cena.finalna = cena.netto)
}



# Zadanie 4 ---------------------------------------------------------------

### a) Wygeneruj wektor abc jako dowolna sekwencje 50 liczb
### b) Stworz zmienna z wylosowana dowolna liczba N z zakresu 1:50
### c) Za pomoca petli stworz wektor abc.do.kwadratu, ktory bedzie 
###    zawieral N pierwszych liczb wektora abc podniesionych do kwadratu
### d) W konsoli pojawi sie odpowiednio N komunikatow "Kwadratem liczby ... jest liczba ..."

rm(list = ls())

# a)
abc <- c(51:100)

# b)
N <- sample(1:50, 1)

# c) & d)
for (i in 1:N) {
    if (i == 1) {
        abc.do.kwadratu <- c()
        abc.do.kwadratu <- append(abc.do.kwadratu, abc[i]^2)
        print(paste("Kwadratem liczby", abc[i], "jest liczba", abc.do.kwadratu[i]))
    } else {
        abc.do.kwadratu <- append(abc.do.kwadratu, abc[i]^2)
        print(paste("Kwadratem liczby", abc[i], "jest liczba", abc.do.kwadratu[i]))
    }
}


# Zadanie 5 ---------------------------------------------------------------

### Napisz petle, ktora na podstawie wektora A (sekwencja liczb 1:100) stworzy wektor X, taki ze:
### x[1] = a[1]
### x[2] = a[1] + a[2]
### x[3] = a[1] + a[2] + a[3]
### ....
rm(list = ls())

a <- 1:100
x <- c()

for (i in a) {
    x <- append(x, sum(a[1:i]))
}
