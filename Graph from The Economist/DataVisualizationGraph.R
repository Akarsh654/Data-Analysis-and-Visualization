# This code recreates a graph from The Economist https://www.economist.com/graphic-detail/2011/12/02/corrosive-corruption
library(ggplot2)
library(data.table)
library(ggthemes)
library(plotly)

# read the file and drop the first column
df <- fread("Economist_Data.csv",drop = 1)

# create a scatter plot using ggplot and add features to it 
pl <- ggplot(df,aes(x=CPI,y=HDI)) + geom_point(aes(color=Region),size=4,shape=1)
pl2 <- pl + geom_smooth(aes(group=1),method = "lm",formula = y ~ log(x),se = FALSE,color="red")

# store the points to label as a character vector
pointsToLabel <- c("Russia", "Venezuela", "Iraq", "Myanmar", "Sudan",
                   "Afghanistan", "Congo", "Greece", "Argentina", "Brazil",
                   "India", "Italy", "China", "South Africa", "Spane",
                   "Botswana", "Cape Verde", "Bhutan", "Rwanda", "France",
                   "United States", "Germany", "Britain", "Barbados", "Norway", "Japan",
                   "New Zealand", "Singapore")

# add the labels on the points,the x-axis and y-axis labels, the title and the economist theme
pl3 <- pl2 + geom_text(aes(label = Country), color = "gray20", 
                       data = subset(df, Country %in% pointsToLabel),check_overlap = TRUE)
pl4 <- pl3 + theme_bw()
pl5 <- pl4 + scale_x_continuous(name="Corruption Perceptions Index, 2011 (10=least corrupt)",
                                limits = c(0.9,10.5),breaks = 1:10)
pl6 <- pl5 + scale_y_continuous(name = "Human Development Index, 2011 (1=Best)",
                                limits = c(0.2, 1.0))
pl7 <- pl6 + ggtitle("Corruption and Human development") + theme_economist_white()

# use the plotly library to addinteractive feautures to the graph
pl8 <- ggplotly(pl7)
print(pl8)
