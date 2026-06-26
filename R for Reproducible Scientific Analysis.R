#using r as a calculatr
1 + 100

#bodmas
3 + 5 * 2
(3 + 5) * 2
(3 +(5 *(2 ^ 2))) #hard to read
3 + 5 * 2 ^ 2 #clear, if you remember the bodmas rules
sin(1)
log(1) #natural log
log10(10) #base 10 log
exp(0.5) #e^(1/2)
log(exp(1))
#comparing stuff
1 == 1 #two equals signs,read as "is equal to"
1 != 2 #inequality (read as "is not equal to")
1 < 2 #less than
1 <= 1 # less than or equal to
1 > 0  # greater than
1 >= -9 # greater than or equal to

#assigning variables
x <- 1/40
x
log(x)
x <- 100
x
x <- x + 1
y <- x * 2

#vectorization
1:5
2 ^ (1:5)
x <- 1:5
2 ^ x
ls()

#install packages
install.packages("ggplot2")
install.packages("plyr")
install.packages("gapminder")

#or
install.packages (c("ggplot2", "plyr", "gapminder"))

install.packages("Rtools")


###PROJECT MANAGEMENT WITH R
#concatenate c function
c(1, 2, 3)
c("d","e", "f")
c(1, 2, 'f')

#paste function
?paste
paste(c(3, 4, 5), collapse = "L")

paste(c("a","b"), "c") 
paste(c("a","b"), "c", ",")
paste(c("a","b"), "c", sep = ",")
paste(c("a","b"), "c", collapse = "|")
paste(c("a","b"), "c", sep = ",", collapse = "|")

#read.table function
#The standard R function for reading tab-delimited files with a period decimal separator is read.delim(). 
??"read.table"

###Data structures
cats <- data.frame(coat = c("calico", "black","tabby"), weight = c(2.1, 5.0, 3.2), likes_catnip = c(1, 0, 1))

write.csv(x = cats, file = "data/feline_data.csv", row.names = FALSE)
cats <- read.csv(file = "data/feline_data.csv")
cats

str(cats)
cats$weight
cats$coat
#say we discovered the scale weighs 2kg light
cats$weight + 2
#announce type of cat
paste("My catty is", cats$coat)
#data types in R
typeof(cats$weight)
typeof(3.22)
typeof(1L)
typeof(1 + 1i)
typeof(TRUE)
typeof("cat")

additional_cat <- data.frame(coat = "tabby", weight = "2.3 or 2.4", likes_catnip = 1)
additional_cat

cats2 <- rbind(cats, additional_cat)
cats2

typeof(cats2$weight)
str(cats2)

#vectors
my_vector <- vector(length = 3)
anada_vector <- vector(mode = "character", length = 3)
str(anada_vector)

character_vector_hapa <- c('0','2','4')
character_kuwa_double <- as.double(character_vector_hapa)

cats$likes_catnip <- as.logical(cats$likes_catnip)


ab_vector <- c("a", "b")
ab_vector
combine_example <- c(ab_vector, "SWC")
combine_example
my_series <- 1:10
my_series
seq(10)
seq(1, 10, by = 0.1)

sequence_example <- 20:25
head(sequence_example, n=2)
tail(sequence_example, n=4)
length(sequence_example)
typeof(sequence_example)

first_element <- sequence_example[1]
first_element
sequence_example[1] <- 30
sequence_example

#challenge : Start by making a vector with the numbers 1 through 26. Then, multiply the vector by 2.

vec_multiply <- 1:26
vec_multiply * 2


#lists
list_example <- list(1, "a", TRUE, 1 + 4i)
list_example
str(list_example)

list_example[[2]]

another_list <- list(title = "Numbers", numbers = 1:10, data = TRUE)
another_list
another_list$title
another_list$numbers

pizza_price <- c(pizzasubito = 5.64, pizzafesh = 6.60, callapizza = 4.50)
pizza_price["pizzasubito"]
names(pizza_price)
names(pizza_price)[3]
names(pizza_price)[3] <- "call-a-pizza"
pizza_price

typeof(names(pizza_price))
str(pizza_price)
str(names(pizza_price))

letter_no <- 1:26
names(letter_no) <- LETTERS
letter_no["B"]

#DATAFRAMES
cats
typeof(cats)
class(cats)

cats$coat
cats[,1]
typeof(cats[,1])
str(cats[,1])
cats[1,]
typeof(cats[1,])
str(cats[1,])

#challenge
cats[1]
cats[[1]]
cats$coat
cats["coat"]
cats[1, 1]
cats[, 1]
cats[1, ]

typeof(cats[1])
typeof(cats[[1]])
typeof(cats$coat)
typeof(cats["coat"])
typeof(cats[1, 1])
typeof(cats[, 1])
typeof(cats[1, ])

names(cats)
names(cats)[2] <- "weight_kg"
cats

#Matrices matrix
matrix_example <- matrix(0, ncol = 6, nrow = 3)
matrix_example
dim(matrix_example)
typeof(matrix_example)
class(matrix_example)
str(matrix_example)
nrow(matrix_example)
ncol(matrix_example)
length(matrix_example)


matrix_50 <- matrix(1:50, ncol = 5, nrow = 10)
matrix_50
matrix_50 <- matrix(1:50, ncol = 5, nrow = 10, byrow = TRUE) #FILL BY ROW

list_final <- list(DataTypes = c("double","integer", "complex", "logical", "character"), DataStructures = c("dataFrame", "vector", "list", "matrix"))
list_final


matrix(c(4, 9, 10, 1, 5, 7), nrow = 2)


#adding rows n columns
age <- c(2, 3, 5)
cats
cbind(cats, age)
nrow(cats)
length(age)
newRow <- list("tortoise", 3.3, TRUE, 9)
cats <- rbind(cats, newRow)
cats

#removing rows
cats[-4, ]
cats[-4:-2, ]
cats[-2, ]

cats[,-4]
drop <- names(cats) %in% c("age")
cats[,!drop]

#appending to a data frame
my_data_frame <- data.frame(firstName = "Lord", lastName = "Kheem", luckyNumber = 33)
my_data_frame
weru <- c("Anneh", "Bobo", 27)
weru
dahlia <- c("Mercy", "Njango", 13)
dahlia
petra <- c("Diana", "Petra", 25)
petra
rbind(my_data_frame, weru, dahlia, petra)
my_data_frame <- rbind(my_data_frame, weru, dahlia, petra)
timeForCOffee <- c(TRUE, TRUE, FALSE, FALSE)
my_data_frame <- cbind(my_data_frame, timeForCOffee)


####REALISTIC EXAMPLE
gapminder <- read.csv("data/gapminder_data.csv")
str(gapminder)
summary(gapminder)
typeof(gapminder$pop)
typeof(gapminder$year)
typeof(gapminder$continent)
str(gapminder$continent)

colnames(gapminder)
head(gapminder)

#challenge
tail(head(gapminder, n = 417), n = 15) #created a nested operation based on a trick i learnt from unix shell pipes and filters

#What about getting a (pseudorandom) sample? R also has a function for this
gapminder[sample(nrow(gapminder), 5), ] #nrow(gapminder) returns the number of rows i.e 1704,sample takes this -(1704)- and 5 as its arguments. it returns a sequeence of  5 random numbers, thats inserted into gapminder [ , ] as the argument for the rows


##subsetting
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c("a", "b", "c", "d", "e")
x

x[ ] #ask for the nth element
x[4]#4th element
x[c(1,3)]#the 1st and 3rd elements
x[2:5] #element 2 through 5
x[c(2,2,3)] #element 2 twice and element 3
x[6] #missing value since its beyond the length of the vector
x[0]#empty vector

#skipping and removing elements
x[-4] #every element of the vector except the 4th
x[c(-1, -5)] # or x[-c(1,5)]

#to remove elements from a vector, we need to assign the result back into the variable
x <- x[-4]
x

#challenge
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
print(x)

x[2:4]
x[-c(1,5)]
x[c(-1, -5)]

#subsetting by name
x <- c(a=5.4, b=6.2, c=7.1, d=4.8, e=7.5) # we can name a vector 'on the fly'
x[c("a", "c")]

#subsetting using logical operations
x[c(FALSE, FALSE, TRUE, FALSE, TRUE)]
x[x > 7] #Breaking it down, this statement first evaluates x>7, generating a logical vector c(FALSE, FALSE, TRUE, FALSE, TRUE), and then selects the elements of x corresponding to the TRUE value
x[names(x) == "a"]


#challenge
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
print(x)

x[x < 7 & x > 4]

#skipping named elements
x[names(x) != "a"] #remember to keep ! and = together

x[names(x) != c("a", "c")] #this one gives the wrong answer because it recycles the values a,c while comparing to the initial vector length 5
#look at this one ...it gives us a wrong answer because recycling doesn't affect its logic flow..although the method is wrong
x[names(x) != c("a", "b")]

#The way to get R to do what we really want (match each element of the left argument with all of the elements of the right argument) it to use the %in% operator. The %in% operator goes through each element of its left argument, in this case the names of x, and asks, “Does this element occur in the second argument?”. Here, since we want to exclude values, we also need a ! operator to change “in” to “not in”:
x[! names(x) %in% c("a","c") ]



#factor subsetting
kaFactor <- factor(c("a", "a", "b", "c", "c", "d"))
kaFactor[kaFactor == "a"]
kaFactor[kaFactor %in% c("b", "c")]
kaFactor[1:3]
kaFactor[-3]

#matrix subsetting
set.seed(1)
matty <- matrix(rnorm(6 * 4),ncol = 4, nrow = 6)
matty[3:4, c(3, 1)]
matty[ , c(3, 4)]
matty[3,] #R automatically converts one row or column into a  vector
matty[4, , drop = FALSE] #you need to specify a third argument to keep the output as a matrix
matty[5] #matrices are laid out in column-major format by default. That is the elements of the vector are arranged column-wise:
matty

#List subsetting
xlist <- list(a = "Software Carpentry", b = 1:10, data = head(mtcars))
xlist[1] #returns as list of one element
xlist[1:2] #first two elements of the list and not the individual elements
#to extract individual elements use double [[]]
xlist[[1]] #now its a vector not a list
xlist[[1:2]] #YOU CANT USSE IT TO EXTRACT MORE THAN ONE ELEMENT AT ONCE
XLIST[[-1]] #OR TO SKIP ELEMENTS
#but you can use names to eubset and extract elements
xlist[["a"]]
xlist$data

#challenge extract the number 2 from xlist which is in the "b" item of the list
xlist[[2]][2]
xlist$b[2]
xlist[["b"]][2]


mod <- aov(pop ~ lifeExp, data = gapminder)
attributes(mod)
mod$df.residual

#subsetting dataframes
head(gapminder[3]) #returns a list
#Similarly, [[ will act to extract a single column in vector form
head(gapminder[["lifeExp"]])
head(gapminder$year)
gapminder[1:3, ]
gapminder[3,]

#extract obs collected for the year 1957
gapminder[gapminder$year == 1957, ]

#extract all columns except 1 through to 4
gapminder[,-c(1:4)]

#Extract the rows where the life expectancy is longer the 80 years
gapminder[gapminder$lifeExp > 80,]

#Extract the first row, and the fourth and fifth columns (continent and lifeExp).
gapminder[1, 4:5]

#Advanced: extract rows that contain information for the years 2002 and 2007
gapminder[gapminder$year == 2002 | gapminder$year == 2007,]
gapminder[gapminder$year %in% c(2002, 2007), ]

#Create a new data.frame called gapminder_small that only contains rows 1 through 9 and 19 through 23. You can do this in one or two steps

gapminderSmall <- gapminder[1:9, ]
gapminderSmall <- rbind(gapminderSmall, gapminder[19:23, ])
#or
gapminder_small <- gapminder[c(1:9, 19:23), ]



#CONTROL FLOW
# if
if (condition is true) {
  perform action
}

# if ... else
if (condition is true) {
  perform action
} else {  # that is, if the condition is false,
  perform alternative action
}

#for
for (iterator in set of values) {
  do a thing
}

#while
while(this condition is true){
  do a thing
}



#Write a script that loops over each country in the gapminder dataset, tests whether the country starts with a ‘B’, and graphs life expectancy against time as a line graph if the mean life expectancy is under 50 years.


thresholdValue <- 50
candidateCountries <- grep("^B", unique(gapminder$country), value = TRUE)

for (iCountry in candidateCountries) {
  tmp <- mean(gapminder[gapminder$country == iCountry, "lifeExp"])
  
  if (tmp < thresholdValue) {
    cat("Average Life Expectancy in", iCountry, "is less than", thresholdValue, "plotting life expectancy graph... \n")
    
    with(subset(gapminder, country == iCountry),
         plot(year, lifeExp,
              type = "o",
              main = paste("Life Expectancy in", iCountry, "over time"),
              ylab = "Life Expectancy",
              xlab = "Year"
         ) # end plot
    ) # end with
  } # end if
  rm(tmp)
} # end for loop


library("ggplot2")
ggplot(data = gapminder)

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp))
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp)) + geom_point()
?ggplot

ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent)) + geom_point()

ggplot(data = gapminder, mapping = aes(x = continent, y = lifeExp, color = as.character(year))) + geom_point()

ggplot(data = gapminder, mapping = aes(x = country, y = gdpPercap, color = as.character(year))) + geom_point()

ggplot(data = gapminder, mapping = aes(x = continent, y = lifeExp, color = as.character(year))) + geom_point()
unique(gapminder$year)
length(unique(gapminder$year))

gapminder[grep(1962, gapminder$year), ]

ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, group=country, color=continent)) +
  geom_line()

min(gapminder$lifeExp)

ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, group=country, color=continent)) +
  geom_line() + geom_point()

ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, group=country)) +
  geom_line(mapping = aes(color=continent)) + geom_point()

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + scale_x_log10()

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + scale_x_log10() + geom_smooth(method="lm")

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size = 3, color = "orange") + scale_x_log10() + geom_smooth(method="lm", linewidth = 1.5)


americas <- gapminder[gapminder$continent == "Americas",]
ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme(axis.text.x = element_text(angle = 45))


ggplot(data = americas, mapping = aes(x = year, y = lifeExp, color=continent)) +
  geom_line() + facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#exportinng the plots using ggsave
lifeExp_plot <- ggplot(data = americas, mapping = aes(x = year, y = lifeExp, color=continent)) +
  geom_line() + facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave(filename = "results/lifeExp.png", plot = lifeExp_plot, width = 12, height = 10, dpi = 300, units = "cm")


##Vectorization

gapminder$pop_millions <- gapminder$pop / 1e6
head(gapminder)

##any() will return TRUE if any element of a vector is TRUE.
#all() will return TRUE if all elements of a vector are TRUE.

#cerate a function
my_function <- function(parameters) {
  # perform action
  # return value
}


fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

fahr_to_kelvin(32)
fahr_to_kelvin(212)

kelv_to_celsius <- function(temp){
  celsius <- (temp-273.15)
  return(celsius)
}

kelv_to_celsius(fahr_to_kelvin(212))

##Defensive programming

fahr_to_kelvin <- function(temp) {
  if (!is.numeric(temp)) {
    stop("temp must be a numeric vector.")
  }
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

fahr_to_kelvin("fifty")
fahr_to_kelvin(j)

#We can list as many requirements that should evaluate to TRUE; stopifnot() throws
fahr_to_kelvin <- function(temp) {
  stopifnot(is.numeric(temp))
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

fahr_to_kelvin(temp = as.factor(32))



#the function now subsets the provided data by year if the year argument isn’t empty, then subsets the result by country if the country argument isn’t empty. Then it calculates the GDP for whatever subset emerges from the previous two steps. The function then adds the GDP as a new column to the subsetted data and returns this as the final result. You can see that the output is much more informative than a vector of numbers.
calcGDP <- function(dat, year=NULL, country=NULL) {
  if(!is.null(year)) {
    dat <- dat[dat$year %in% year, ]
  }
  if (!is.null(country)) {
    dat <- dat[dat$country %in% country,]
  }
  gdp <- dat$pop * dat$gdpPercap
  
  new <- cbind(dat, gdp=gdp)
  return(new)
}

#when we specify the year
head(calcGDP(gapminder, year=2007))

#Or for a specific country
calcGDP(gapminder, country="Australia")

#or both
calcGDP(gapminder, year=2007, country="Australia")

##writing data
pdf("Life_Exp_vs_time.pdf", width=12, height=4)
ggplot(data=gapminder, aes(x=year, y=lifeExp, colour=country)) +
  geom_line() +
  theme(legend.position = "none")
dev.off()


pdf("Life_Exp_vs_time.pdf", width = 12, height = 4)
p <- ggplot(data = gapminder, aes(x = year, y = lifeExp, colour = country)) +
  geom_line() +
  theme(legend.position = "none")
p
p + facet_grid(~continent)
dev.off()


aust_subset <- gapminder[gapminder$country == "Australia",]

write.table(aust_subset,
            file="C:/BstSetup/BSTData/Archive/Media/R learning/R/gapminder_project/cleaned-data/gapminder-aus.csv",
            sep=","
)


###DPLYR


library("dplyr")


mean(gapminder$gdpPercap[gapminder$continent == "Africa"])
mean(gapminder$gdpPercap[gapminder$continent == "Americas"])
mean(gapminder$gdpPercap[gapminder$continent == "Asia"])

#Using select()
year_country_gdp <- select(gapminder, year, country, gdpPercap)

smaller_gapminder_data <- select(gapminder, -continent)

year_country_gdp <- gapminder %>% select(year, country, gdpPercap)


#Within a pipeline, the syntax is rename(new_name = old_name)
tidy_gdp <- year_country_gdp %>% rename(gdp_per_capita = gdpPercap)
head(tidy_gdp)

#using filter()
year_country_gdp_euro <- gapminder %>%
  filter(continent == "Europe") %>%
  select(year, country, gdpPercap)

#european countries life expectancy
europe_lifeExp_2007 <- gapminder %>%
  filter(continent == "Europe", year == 2007) %>%
  select(country, lifeExp)

#using group_by()
str(gapminder %>% group_by(continent))

#using summarise()
gdp_bycontinents <- gapminder %>%
  group_by(continent) %>%
  summarize(mean_gdpPercap = mean(gdpPercap))

life_exp_bycountry <- gapminder %>%
  group_by(country) %>%
  summarise(mean_lifeExp = mean(lifeExp))

#The function group_by() allows us to group by multiple variables. Let’s group by year and continent.
gdp_bycontinents_byyear <- gapminder %>%
  group_by(continent, year) %>%
  summarize(mean_gdpPercap = mean(gdpPercap))

#That is already quite powerful, but it gets even better! You’re not limited to defining 1 new variable in summarize().
gdp_pop_bycontinents_byyear <- gapminder %>%
  group_by(continent, year) %>%
  summarize(mean_gdpPercap = mean(gdpPercap),
            sd_gdpPercap = sd(gdpPercap),
            mean_pop = mean(pop),
            sd_pop = sd(pop))

#count() and n()
gapminder %>%
  filter(year == 2002) %>%
  count(continent, sort = TRUE)

#need to use the number of observations in calculations, the n() function is useful . For instance, if we wanted to get the standard error of the life expectency per continent:

gapminder %>%
  group_by(continent) %>%
  summarize(se_le = sd(lifeExp)/sqrt(n()))

gapminder %>%
  group_by(continent) %>%
  summarize(
    mean_le = mean(lifeExp),
    min_le = min(lifeExp),
    max_le = max(lifeExp),
    se_le = sd(lifeExp)/sqrt(n()))

#using mutate()
gdp_pop_bycontinents_byyear <- gapminder %>%
  mutate(gdp_billion = gdpPercap*pop/10^9) %>%
  group_by(continent,year) %>%
  summarize(mean_gdpPercap = mean(gdpPercap),
            sd_gdpPercap = sd(gdpPercap),
            mean_pop = mean(pop),
            sd_pop = sd(pop),
            mean_gdp_billion = mean(gdp_billion),
            sd_gdp_billion = sd(gdp_billion))

## keeping all data but "filtering" after a certain condition
# calculate GDP only for people with a life expectation above 25
gdp_pop_bycontinents_byyear_above25 <- gapminder %>%
  mutate(gdp_billion = ifelse(lifeExp > 25, gdpPercap * pop / 10^9, NA)) %>%
  group_by(continent, year) %>%
  summarize(mean_gdpPercap = mean(gdpPercap),
            sd_gdpPercap = sd(gdpPercap),
            mean_pop = mean(pop),
            sd_pop = sd(pop),
            mean_gdp_billion = mean(gdp_billion),
            sd_gdp_billion = sd(gdp_billion))

gapminder %>%
  # extract first letter of country name into new column
  mutate(startsWith = substr(country, 1, 1)) %>%
  # only keep countries starting with A or Z
  filter(startsWith %in% c("A", "Z")) %>%
  # plot lifeExp into facets
  ggplot(aes(x = year, y = lifeExp, colour = continent)) +
  geom_line() +
  facet_wrap(vars(country)) +
  theme_minimal()
## updating only if certain condition is fullfilled
# for life expectations above 40 years, the gpd to be expected in the future is scaled
gdp_future_bycontinents_byyear_high_lifeExp <- gapminder %>%
  mutate(gdp_futureExpectation = ifelse(lifeExp > 40, gdpPercap * 1.5, gdpPercap)) %>%
  group_by(continent, year) %>%
  summarize(mean_gdpPercap = mean(gdpPercap),
            mean_gdpPercap_expected = mean(gdp_futureExpectation))

#combine dplyr and ggplot2
gapminder %>%
  # Filter countries located in the Americas
  filter(continent == "Americas") %>%
  # Make the plot
  ggplot(mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme(axis.text.x = element_text(angle = 45))


lifeExp_2countries_bycontinents <- gapminder %>%
  filter(year==2002) %>%
  group_by(continent) %>%
  slice_sample(n=2) %>%
  summarize(mean_lifeExp=mean(lifeExp)) %>%
  arrange(desc(mean_lifeExp))
