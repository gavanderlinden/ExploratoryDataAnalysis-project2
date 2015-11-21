library(dplyr)
library(ggplot2)

# load National Emissions Inventory and Source Classification Code data sets
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC_ <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# select all ids for coal combustion-related sources
SCC_coal <- SCC_ %>%
    filter(grepl("fuel comb -(.*)- coal", EI.Sector, ignore.case=T)) %>%
    select(SCC) %>%
    mutate(SCC = as.character(SCC))

# sum emissions for each type of sources
coal_emissions_year <- NEI %>%
    filter(SCC %in% SCC_coal$SCC) %>%
    group_by(year, type) %>% 
    summarise(total_emissions = sum(Emissions))

# plot for each type of sources
png("plot4.png")
qplot(year, total_emissions, data=coal_emissions_year, facets = . ~ type, geom="line")
dev.off()