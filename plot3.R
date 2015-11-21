library(dplyr)
library(ggplot2)

# load National Emissions Inventory data set
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

# sum emission per year for Baltimore City
total_emissions_year = NEI %>%
    filter(fips == "24510") %>%
    group_by(year, type) %>% 
    summarise(total_emissions = sum(Emissions))

# plot for each type of sources
png("plot3.png", width = 960, height = 480)
qplot(year, total_emissions, data=total_emissions_year, facets = . ~ type, geom="line")
dev.off()