################ Zarathelle Resin and Crafts Product and Customer Analysis  ###############

Zarathelle_df <- read.csv("Zarathelle 2021 Orders Dataset V1 - Cleaned Data.csv")
View(Zarathelle_df)

# Rename columns
Zarathelle_df_V2 <- Zarathelle_df %>% 
    rename("First_name" = "First.Name",
         "Last_name" = "Last.Name",
         "City_or_municipality" = "City.Municipality",
         "Mode_of_payment" = "Mode.of.Payment",
         "Shipping_fee" = "Shipping.Fee",
         "Product1" = "Order.1",
         "Product2" = "Order.2",
         "Product3" = "Order.3",
         "Product4" = "Order.4",
         "Total_product_quantity" = "Total.Order.Quantity",
         "Total_amount_paid" = "Total.Amount.Paid")
View(Zarathelle_df_V2)

# Remove unnecessary and merged data for reorganization
Zarathelle_df_V3 <- subset(Zarathelle_df_V2, select = -c(Total.Amount.Paid.1,
                                                         Total.Shipping,
                                                         Gross.for.the.Month,
                                                         Total.Gross,
                                                         Total.Net.for.the.Month,
                                                         Total.Net.for.the.Year))
View(Zarathelle_df_V3)

# Create an auto increment ID for each purchase
Zarathelle_df_V4 <- Zarathelle_df_V3 %>% 
  mutate(ID = row_number()) %>% 
  select(Date,ID, everything())
View(Zarathelle_df_V4)

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

View(Zarathelle_df_V4)

