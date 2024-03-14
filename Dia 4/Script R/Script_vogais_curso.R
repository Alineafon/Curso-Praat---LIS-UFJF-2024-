## Script formantes de vogais do PB ##

# Escolher o diretório de trabalho
setwd("~/Desktop/LIS/Dia 2")

# carregar os dados em um dataframe
Vogais <- read.csv("vogais_curso.csv", header = T, sep = ";") 

# Transformar os caracteres em fatores
library(dplyr)
Vogais <- Vogais %>% mutate_if(sapply(Vogais, is.character), as.factor)

# Verificar nível das vogais
levels(Vogais$Vogal)


# visualizar tabela
Vogais


# Criar um vetor com as vogais em alfabeto fonético para usar nos gráficos
vogais <- c("i", "e",'\u025B', "a",'\u254', "o", "u")


# Gráfico de linhas com as vogais 

plot(Vogais[1:7, 3],
     Vogais[1:7, 2],
     ylim = c(1000, 250),
     xlim = c(2500, 500),
     ylab = " F1(Hz)",
     xlab = " F2(Hz)",
     type = "o",
     pch = vogais,
     col = "firebrick")
title("Vogais do PB de Falante do sexo Feminino")

# Gráficos de linhas parciais

plot(Vogais[1:1, 3],
     Vogais[1:1, 2],
     ylim = c(1000, 250),
     xlim = c(2500, 500),
     ylab = " F1(Hz)",
     xlab = " F2(Hz)",
     type = "o",
     pch = vogais,
     col = "firebrick")
title ("Vogais do PB de Falante do sexo Feminino")

plot(Vogais[1:2, 3],
     Vogais[1:2, 2],
     ylim = c(1000, 250),
     xlim = c(2500, 500),
     ylab = " F1(Hz)",
     xlab = " F2(Hz)",
     type = "o",
     pch = vogais,
     col = "firebrick")
title ("Vogais do PB de Falante do sexo Feminino")

plot(Vogais[1:3, 3],
     Vogais[1:3, 2],
     ylim = c(1000, 250),
     xlim = c(2500, 500),
     ylab = " F1(Hz)",
     xlab = " F2(Hz)",
     type = "o",
     pch = vogais,
     col = "firebrick")
title ("Vogais do PB de Falante do sexo Feminino")

plot(Vogais[1:4, 3],
     Vogais[1:4, 2],
     ylim = c(1000, 250),
     xlim = c(2500, 500),
     ylab = " F1(Hz)",
     xlab = " F2(Hz)",
     type = "o",
     pch = vogais,
     col = "firebrick")
title ("Vogais do PB de Falante do sexo Feminino")

plot(Vogais[1:5, 3],
     Vogais[1:5, 2],
     ylim = c(1000, 250),
     xlim = c(2500, 500),
     ylab = " F1(Hz)",
     xlab = " F2(Hz)",
     type = "o",
     pch = vogais,
     col = "firebrick")
title ("Vogais do PB de Falante do sexo Feminino")

plot(Vogais[1:6, 3],
     Vogais[1:6, 2],
     ylim = c(1000, 250),
     xlim = c(2500, 500),
     ylab = " F1(Hz)",
     xlab = " F2(Hz)",
     type = "o",
     pch = vogais,
     col = "firebrick")
title ("Vogais do PB de Falante do sexo Feminino")

plot(Vogais[1:7, 3],
     Vogais[1:7, 2],
     ylim = c(1000, 250),
     xlim = c(2500, 500),
     ylab = " F1(Hz)",
     xlab = " F2(Hz)",
     type = "o",
     pch = vogais,
     col = "firebrick")
title ("Vogais do PB de Falante do sexo Feminino")

