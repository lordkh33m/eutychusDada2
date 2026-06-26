thresholdValue <- 50

for (iContinent in unique(gapminder$continent)) {
  tmp <- mean(gapminder[gapminder$continent == iContinent, "lifeExp"])
  
  if (tmp < thresholdValue){
    cat("Average Life Expectancy in", iContinent, "is less than", thresholdValue, "\n")
  } else {
    cat("Average Life Expectancy in", iContinent, "is greater than", thresholdValue, "\n")
  } # end if else condition
  rm(tmp)
} # end for loop



##challenge
thresholdValue_1 <- 50
thresholdValue_2 <- 70

for (iCountry in unique(gapminder$country)) {
  tmp <- mean(gapminder[gapminder$country == iCountry, "lifeExp"])
  
  if (tmp > thresholdValue_2){
    cat("Average Life Expectancy in", iCountry, "is greater than", thresholdValue_2, "\n")
  } else if(tmp > thresholdValue_1) {
    cat("Average Life Expectancy in", iCountry, "is greater than", thresholdValue_1,"but less than ", thresholdValue_2, "\n")
  } else
    cat("Average Life Expectancy in", iCountry, "is less than", thresholdValue_1, "\n")# end if else condition
  rm(tmp)
} # end for loop