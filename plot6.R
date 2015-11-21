library(dplyr)
library(ggplot2)

# load National Emissions Inventory and Source Classification Code data sets
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC_ <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# select all ids for motor vehicle sources
SCC_mobile_vehicles <- SCC_ %>%
    filter(grepl("mobile .* (vehicles|vessels|aircraft|locomotives)", EI.Sector, ignore.case=T)) %>%
    select(SCC) %>%
    mutate(SCC = as.character(SCC))

# sum emissions for both Baltimore and Los Angeles
NEI_mobile_vehicles <- NEI %>%
    filter(fips %in% c("24510", "06037")) %>%
    inner_join(SCC_mobile_vehicles, by="SCC") %>%
    group_by(year, fips) %>%
    summarise(total_emissions = sum(Emissions))

# replace fips codes with proper labels
NEI_mobile_vehicles$fips <- gsub("06037", "Los Angeles County", NEI_mobile_vehicles$fips)
NEI_mobile_vehicles$fips <- gsub("24510", "Baltimore City", NEI_mobile_vehicles$fips)

# plot for each fips
png("plot6.png")
qplot(year, total_emissions, data=NEI_mobile_vehicles, facets = . ~ fips, geom="line")
dev.off()
    