################  Zarathelle Resin and Crafts 2021 Data Visualization   ###############


# Graph of total gross income per month

ggplot(Total_gross_income_per_month, aes(x = Month_ordered, y = Total_gross_income_per_month)) + 
  geom_bar(stat = "identity", width = 0.5, fill = "tomato3") + 
  labs(title = "Gross Income per Month", 
       caption = "source: Zarathelle Resin and Crafts") + 
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))


# Data visualization of customer with highest product order quantity by month

ggplot(Customer_with_highest_order_quantity, aes(x = Month_ordered,
                                                 y = Highest_order_quantity,
                                                 fill = First_name)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Customers with Highest Order Quantity by Month",
       x = "Month",
       y = "Highest Order Quantity",
       fill = "Customer First Name",
       caption = "source: Zarathelle Resin and Crafts") +
  theme_minimal()


# Data visualization for customer count per province

ggplot(Province_counts, aes(x=Province, y=Num_buyers)) + 
  geom_point(size=3) + 
  geom_segment(aes(x=Province, 
                   xend=Province, 
                   y=0, 
                   yend=Num_buyers)) + 
  labs(title="Customer Count per Province", 
       x = "Province",
       y = "Number of Buyers",
       caption = "source: Zarathelle Resin and Crafts") + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


# Data visualization for customer count per city or municipality

ggplot(City_counts, aes(x=City_or_municipality, y=Num_city_buyers)) + 
  geom_point(size=3) + 
  geom_segment(aes(x=City_or_municipality, 
                   xend=City_or_municipality, 
                   y=0, 
                   yend=Num_city_buyers)) + 
  labs(title="Customer Count per City/Municipality", 
       x = "City or Municipality",
       y = "Number of Buyers",
       caption = "source: Zarathelle Resin and Crafts") + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


# Data visualization for most used mode of payment

color_palette <- brewer.pal(n = nrow(Mop_counts), name = "Set3")

ggplot(Mop_counts, aes(x = "", y = Percentage, fill = Mode_of_payment)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste0(Percentage, "%")), 
            position = position_stack(vjust = 0.5),
            size = 3) +
  labs(title = "Mode of Payment Used by Customers Distribution",
       x = NULL,
       y = NULL,
       fill = "Mode of Payment",
       caption = "source: Zarathelle Resin and Crafts") +
  scale_fill_manual(values = color_palette) + 
  theme_minimal()



# Data visualization in identifying the best selling product in 2021

max_quantity <- max(sum_product_purchase_quantities$Total_Quantity)

# Data visualization with the highest product highlighted
ggplot(sum_product_purchase_quantities, aes(x = Product, y = Total_Quantity)) + 
  geom_point(size = 3, color = ifelse(sum_product_purchase_quantities$Total_Quantity == max_quantity, "red", "blue")) + 
  geom_segment(aes(x = Product, xend = Product, y = 0, yend = Total_Quantity)) + 
  labs(title = "Best-selling product in 2021", 
       x = "Product",
       y = "Total Order Quantity",
       caption = "source: Zarathelle Resin and Crafts") + 
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))