library(dplyr)
library(ggplot2)

# load National Emissions Inventory and Source Classification Code data sets
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC_ <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# select all ids and sectors for motor vehicle sources
SCC_mobile_vehicles <- SCC_ %>%
    filter(grepl("mobile .* (vehicles|vessels|aircraft|locomotives)", EI.Sector, ignore.case=T)) %>%
    select(SCC, EI.Sector) %>%
    mutate_each_(funs(as.character), c("SCC", "EI.Sector"))

# shorten sectors to fit nicely in plots afterwards
SCC_mobile_vehicles$EI.Sector <- gsub("Mobile - ", "", SCC_mobile_vehicles$EI.Sector)
SCC_mobile_vehicles$EI.Sector <- gsub("On-Road ", "", SCC_mobile_vehicles$EI.Sector)

# sum emissions for each sector
NEI_mobile_vehicles <- NEI %>%
    filter(fips == "24510") %>%
    inner_join(SCC_mobile_vehicles, by="SCC") %>%
    group_by(year, EI.Sector) %>%
    summarise(total_emissions = sum(Emissions))

# plot for each sector
png("plot5.png", width = 960, height = 480)
qplot(year, total_emissions, data=NEI_mobile_vehicles, facets = . ~ EI.Sector, geom="line")
dev.off()