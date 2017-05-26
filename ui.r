library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("Products explorer"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filter"),
             sliderInput("pricemin", "Minimum Price of the Product",
                         0, 1000, 100, step = 10),
             
             sliderInput("pricemax", "Maximum Price of the Product",
                         0, 1000, 100, step = 10),

             sliderInput("salesrankmin", "Minimum Sales Rank of the Product",
                         0, 631800, 10, step = 63180),
             
             sliderInput("salesrankmax", "Maximum Sales Rank of the Product",
                         0, 631800, 10, step = 63180)           
           )
    ),
    column(9,
           ggvisOutput("plot1"),
           wellPanel(
             span("Number of products selected:",
                  textOutput("n_products")
             )
           )
    )
  )
)