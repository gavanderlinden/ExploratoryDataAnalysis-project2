library(dplyr)

# load National Emissions Inventory data set
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

# sum emission per year for Baltimore City
total_emissions_year = NEI %>%
    filter(fips == "24510") %>%
    group_by(year) %>% 
    summarise(total_emissions = sum(Emissions))

# plot
png("plot2.png")
with(total_emissions_year, {
    plot(
        total_emissions ~ year, type="l",
        main="Total emission per year",
        ylab="Total emission"
    )
})
dev.off()