################ Zarathelle Resin and Crafts Product and Customer Analysis  ###############

Zarathelle_df <- read.csv("Zarathelle 2021 Orders Dataset V1 - Cleaned Data.csv")

# Rename columns
Zarathelle_df_V2 <- Zarathelle_df %>% 
    rename("First_name" = "First.Name",
         "Last_name" = "Last.Name",
         "City_or_municipality" = "City.Municipality",
         "Mode_of_payment" = "Mode.of.Payment",
         "Shipping_fee" = "Shipping.Fee",
         "Product_variety1" = "Order.1",
         "Product_variety2" = "Order.2",
         "Product_variety3" = "Order.3",
         "Product_variety4" = "Order.4",
         "Total_product_quantity" = "Total.Order.Quantity",
         "Total_amount_paid" = "Total.Amount.Paid")

# Remove unnecessary and merged data for reorganization
Zarathelle_df_V3 <- subset(Zarathelle_df_V2, select = -c(Total.Amount.Paid.1,
                                                         Total.Shipping,
                                                         Gross.for.the.Month,
                                                         Total.Gross,
                                                         Total.Net.for.the.Month,
                                                         Total.Net.for.the.Year))

# Create an auto increment ID for each purchase
Zarathelle_df_V4 <- Zarathelle_df_V3 %>% 
  mutate(ID = row_number()) %>% 
  select(Date,ID, everything())

# Calculate total gross income for every customer

# Define a function to remove commas and convert to integer
remove_commas_and_convert <- function(x) {
  as.integer(gsub(",", "", x, fixed = TRUE))
}

# Modify the Total_amount_paid and Shipping_fee columns
Zarathelle_df_V4$Total_amount_paid <- remove_commas_and_convert(Zarathelle_df_V4$Total_amount_paid)
Zarathelle_df_V4$Shipping_fee <- remove_commas_and_convert(Zarathelle_df_V4$Shipping_fee)

# Create a new column Total_gross_income_per_purchase
Zarathelle_df_V4$Total_gross_income_per_purchase <- Zarathelle_df_V4$Total_amount_paid - Zarathelle_df_V4$Shipping_fee

# Create new column month ordered from date
Zarathelle_df_V5 <- Zarathelle_df_V4 %>% 
  mutate(Month_ordered = str_extract(as.character(Date), "\\w+")) %>% 
  select(Date, ID, Month_ordered, everything())

# Convert the "Date" column to a date object
Zarathelle_df_V5$Date <- dmy(Zarathelle_df_V5$Date)

# Extract the month from the Date
Zarathelle_df_V5$Month_ordered <- month(Zarathelle_df_V5$Date)

# Calculate total gross income per month
Total_gross_income_per_month <- Zarathelle_df_V5 %>% 
  group_by(Month_ordered) %>% 
  summarize(Total_gross_income_per_month = sum(Total_gross_income_per_purchase))
View(Total_gross_income_per_month)

# Customer with highest number of different product variety ordered
Customer_with_most_product_order_variety <- Zarathelle_df_V5 %>% 
  select(ID, First_name, Last_name, Product_variety1, Product_variety2, Product_variety3, Product_variety4) %>% 
  mutate(Is_customer_with_most_ordered_product_variety = ifelse(!is.na(Product_variety4) & nzchar(Product_variety4),
                                                     "Yes",
                                                     "No"))
View(Customer_with_most_product_order_variety)

# Convert char product quantity to integer
Zarathelle_df_V5$Total_product_quantity <- as.integer(gsub("\\D", "", Zarathelle_df_V5$Total_product_quantity))

is_integer_column <- is.integer(Zarathelle_df_V5$Total_product_quantity)
print(is_integer_column)

# Customer with the highest number of product purchase quantity per month
Customer_with_highest_order_quantity <- Zarathelle_df_V5 %>%
  group_by(Month_ordered) %>%
  filter(Total_product_quantity == max(Total_product_quantity)) %>%
  select(ID, First_name, Last_name, Month_ordered, Highest_order_quantity = Total_product_quantity)
View(Customer_with_highest_order_quantity)

# Filter province with the most number of Zarathelle buyer
Province_counts <- Zarathelle_df_V5 %>% 
  group_by(Province) %>% 
  summarize(Num_buyers = n())

View(Province_counts)

Most_num_buyers <- Province_counts %>% 
  filter(Num_buyers == max(Num_buyers))

print(Most_num_buyers)

#Filter city/municipality with most number of buyer
City_counts <- Zarathelle_df_V5 %>% 
  group_by(City_or_municipality) %>% 
  summarize(Num_city_buyers = n())

View(City_counts)

Most_num_city_buyers <- City_counts %>% 
  filter(Num_city_buyers == max(Num_city_buyers))

print(Most_num_city_buyers)

# Calculate most used mode of payment
Mop_counts <- Zarathelle_df_V5 %>% 
  group_by(Mode_of_payment) %>% 
  summarize(Num_used_MOP = n())

Mop_counts$Percentage <- round((Mop_counts$Num_used_MOP / sum(Mop_counts$Num_used_MOP)) * 100, 2)
View(Mop_counts)

Most_used_MOP <- Mop_counts %>% 
  filter(Num_used_MOP == max(Num_used_MOP))

print(Most_used_MOP)

# Separate the Product_and_Quantity column into two columns: Quantity and Product
Zarathelle_df_V5 <- Zarathelle_df_V5 %>%
  separate(Product_variety1, into = c("Quantity", "Product_variety1"), sep = "-", convert = TRUE) %>% 
  separate(Product_variety2, into = c("Quantity2", "Product_variety2"), sep = "-", convert = TRUE) %>% 
  separate(Product_variety3, into = c("Quantity3", "Product_variety3"), sep = "-", convert = TRUE) %>% 
  separate(Product_variety4, into = c("Quantity4", "Product_variety4"), sep = "-", convert = TRUE)

View(Zarathelle_df_V5)

product_purchase_quantities <- data.frame(
  Product = c(Zarathelle_df_V5$Product_variety1,
              Zarathelle_df_V5$Product_variety2,
              Zarathelle_df_V5$Product_variety3,
              Zarathelle_df_V5$Product_variety4),
  Quantity = c(Zarathelle_df_V5$Quantity,
               Zarathelle_df_V5$Quantity2,
               Zarathelle_df_V5$Quantity3,
               Zarathelle_df_V5$Quantity4)
)

# Calculate best-selling product
sum_product_purchase_quantities <- product_purchase_quantities %>%
  group_by(Product) %>%
  summarize(Total_Quantity = sum(Quantity, na.rm = TRUE)) %>% 
  arrange(desc(Total_Quantity))
View(sum_product_purchase_quantities)
