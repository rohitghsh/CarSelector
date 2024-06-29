# CarSelector
I built a solution to choosing a car to buy based on the 20/10/4 rule. This is a method to buy a vehicle which doesn't break your bank
and makes you go broke.

## What does 20/10/4 rule suggests?
- 20% down payment
- Keep transportation costs below 10%
- Choose a four-year term or less

## Data Source
I had to find a datasource which has the car details such as make, model, trim, year and listed price.
We can use an API or web-scrapper to import the data from reputed websites such as Carmax but for now let's work with a small dataset.

I am working with the following dataset from kaggle:

https://www.kaggle.com/datasets/sidharth178/car-prices-dataset?resource=download

## Shiny
To build this application I used RShiny for it's ease of access to publish web applications and fairly simple structure.

Here's the link to the final application. Enjoy!

https://rohitghsh.shinyapps.io/CarSelector/

References:
https://www.lendingtree.com/auto/20-4-10-rule/#:~:text=To%20apply%20this%20rule%20of,monthly%20income%20on%20transportation%20costs
https://shiny.posit.co/
https://dplyr.tidyverse.org/
