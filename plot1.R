library(dplyr)

# load National Emissions Inventory data set
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

# sum emissions by year
total_emissions_year = NEI %>% 
    group_by(year) %>% 
    summarise(total_emissions = sum(Emissions))

# plot
png("plot1.png")
with(total_emissions_year, {
    plot(
        total_emissions ~ year, type="l",
        main="Total emission per year",
        ylab="Total emission"
    )
})
dev.off()