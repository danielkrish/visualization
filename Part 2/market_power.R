data <- read.csv("/Users/danielkrishevsky/Desktop/vgsales.csv", header=T, sep=",", encoding = "UTF-8")

library(sqldf)

data <- sqldf('SELECT platform, year, global_sales
               FROM data 
               WHERE year != "2017"')

year_market_sales <- sqldf('SELECT year, SUM(global_sales) [market_sales] 
                            FROM data 
                            GROUP BY year
                            ORDER BY year ASC')

platfrom_data <- sqldf('SELECT platform, year, SUM(global_sales) [platform_sales] 
                   FROM data 
                   GROUP BY platform, year
                   ORDER BY platform, year ASC')

new_data <-  sqldf('SELECT p.platform, p.year, p.platform_sales, m.market_sales 
                            FROM platfrom_data p JOIN year_market_sales m
                            on p.year = m.year
                            ORDER BY p.platform, p.year ASC')

new_data <-  sqldf('SELECT platform, COUNT(year) [year_of_activity], MIN(year) [start], MAX(year) [ended],
                      SUM(platform_sales) [platform_sales], SUM(market_sales) [market_sales] 
                    FROM new_data
                    GROUP BY platform')

market_power <-  sqldf('SELECT platform, year_of_activity, platform_sales, market_sales, start, ended,
                        platform_sales/market_sales [market_power]
                        FROM new_data
                        ORDER BY market_power DESC')

write.csv(market_power, "market_power.csv")