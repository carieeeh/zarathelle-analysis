################  Zarathelle Resin and Crafts 2021 Data Visualization   ###############


# Graph of total gross income per month
ggplot(Total_gross_income_per_month, aes(x = Month_ordered, y = Total_gross_income_per_month)) + 
  geom_bar(stat = "identity", width = 0.5, fill = "tomato3") + 
  labs(title = "Gross Income per Month", 
       subtitle = "Make Vs Avg. Mileage", 
       caption = "source: Zarathelle Resin and Crafts") + 
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))

