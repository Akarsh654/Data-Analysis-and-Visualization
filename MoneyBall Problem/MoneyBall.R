
# This code solves the MoneyBall problem of 2001 to replace the 3 players of Oakland A's
# The data is obtained from http://www.seanlahman.com/baseball-archive/statistics/
# To get information about he formulae used check the following wikipedia links:
# https://en.wikipedia.org/wiki/Batting_average
# https://en.wikipedia.org/wiki/Slugging_percentage
# https://en.wikipedia.org/wiki/On-base_percentage

library(dplyr)
library(ggplot2)

# read the data in the files
batting <- read.csv("Batting.csv")
salary <- read.csv('Salaries.csv')

# Batting Average
batting$BA <- batting$H / batting$AB

# On Base Percentage
batting$OBP <- (batting$H + batting$BB + batting$HBP)/(batting$AB + batting$BB + batting$HBP + batting$SF)

# Creating X1B (Singles)
batting$X1B <- batting$H - batting$X2B - batting$X3B - batting$HR

# Creating Slugging Average (SLG)
batting$SLG <- ((1 * batting$X1B) + (2 * batting$X2B) + (3 * batting$X3B) + (4 * batting$HR) ) / batting$AB

# remove the batting data that occured before 1985
batting <- subset(batting,yearID>=1985)

# merge the batting and salary data frames
combo <- merge(batting,salary,by=c('playerID','yearID'))

# get the details of the lost players
lost_players <- subset(combo,playerID %in% c('giambja01','damonjo01','saenzol01'))

# the players were lost after 2001 so get the data when the year was 2001
lost_players <- subset(lost_players,yearID == 2001)

# extract the necessary columns from the data
lost_players <- lost_players[,c('playerID','H','X2B','X3B','HR','OBP','SLG','BA','AB')]

# get available players from 2001
avail_players <- filter(combo,yearID==2001)

# use a scatter plot to check the cut-off for salary with respect to OBP
cutoff <- ggplot(avail_players,aes(x=OBP,y=salary)) + geom_point()
print(cutoff)

# after analyzing the graph we can deduce that we shouldn't pay above 8 million
avail_players <- filter(avail_players,salary<8000000,OBP>0)

# the total AB of the lost players is 1469. This is about 1500,
# so a good cut off for avail_players is at 1500/3= 500 AB
avail_players <- filter(avail_players,AB >= 500)

# get the possible players with the necessary data
possible <- head(arrange(avail_players,desc(OBP)),10)
possible <- possible[,c('playerID','OBP','AB','salary')]
print(possible)

# we can't choose giambja again so we select 2nd to 4th players
selected <- possible[2:4,]
print(selected)


