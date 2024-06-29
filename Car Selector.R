# Load necessary libraries
library(shiny)
library(dplyr)
library(readr)

# Load dataset
load_data <- function(){
  car_data <- read.csv('train.csv')
  car_data <- subset(car_data, select = c(ID, Price, Manufacturer, Model, `Prod..year`, Category, `Fuel.type`,
                                          `Engine.volume`, Mileage, Cylinders, `Gear.box.type`, `Drive.wheels`, `Color`))
  
  convert_to_integer <- function(km_string) {
    # Split the string by space and take the first part
    split_km <- strsplit(km_string, " ")[[1]]
    # Convert to integer
    km_integer <- as.integer(split_km[1])
    return(km_integer)
  }
  # Apply the function to the Mileage column
  car_data$Mileage <- sapply(car_data$Mileage, convert_to_integer)
  # Convert date to year
  car_data$Prod..year <- as.Date(paste0(car_data$Prod..year, "-01-01"))
  
  return(car_data)
}

car_data <- load_data()
car_data
  
# Define UI for the app
ui <- fluidPage(
  titlePanel("Affordable Car Finder"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput('base_annual_salary', 'Enter your base annual salary:', min = 0, step = 1000, value = 10000),
      hr(),
      selectizeInput("make", 'Make:', choices = sort(unique(car_data$Manufacturer)), multiple = TRUE),
      selectizeInput("year", 'Year:', choices = sort(unique(format(car_data$Prod..year, "%Y"))), multiple = TRUE),
      selectizeInput("model", 'Model:', choices = NULL, multiple = TRUE),
      selectizeInput("category", 'Category:', choices = sort(unique(car_data$Category)), multiple = TRUE),
      sliderInput("mileage", 'Mileage:', min = 100, max = 500000, step = 1000 , value = 30000),
      actionButton("go", "Show Cars")
    ),
    
    mainPanel(
      tableOutput('car_table'),
    )
  )
)

# Calculate car price based on user's base annual salary
car_selector <- function(base_annual_salary) {
  car_monthly_expense <- 0.1 * (base_annual_salary / 12)
  mortgage <- car_monthly_expense * 4 * 12
  downpayment <- mortgage * 0.25
  car_price <- downpayment + mortgage
  return(car_price)
}


# Define server logic for the app
server <- function(input, output, session) {

  observe({
    models <- car_data %>% filter(Manufacturer %in% input$make) %>% pull(Model)
    updateSelectizeInput(session, "model", "Model:", choices = unique(models))
  })
  
  observe({
    if (is.null(input$model) || length(input$model) == 0) {
      categories <- car_data %>% filter(Manufacturer %in% input$make) %>% pull(Category)
    } else {
      categories <- car_data %>% filter(Model %in% input$model) %>% pull(Category)
    }
    updateSelectizeInput(session, "category", "Category:", choices = unique(categories))
  })
  
  observeEvent(input$go, {
    max_affordable_price <- car_selector(input$base_annual_salary)

    
    output_table <- car_data %>% 
      filter(
      Price <= max_affordable_price,
      (Manufacturer %in% input$make | is.null(input$make)),
      (format(Prod..year, '%Y') %in% input$year | is.null(input$year)),
      (Model %in% input$model | is.null(input$model)),
      (Category %in% input$category | is.null(input$category)),
      Mileage <= input$mileage
      )
    
    if (nrow(output_table) == 0) {
      showModal(modalDialog(
        title = "No Results",
        "No cars found matching the criteria.",
        easyClose = TRUE,
        footer = NULL
      ))
      output$car_table <- renderTable(data.frame())
      return()
    }
    
    output$car_table <- renderTable(output_table %>% mutate(Prod..year = format(Prod..year, "%Y")))
    
  })
  
}

# Run the app
shinyApp(ui = ui, server = server)
