library(ggvis)
library(dplyr)

load('amazon.rdata')

function(input, output, session) {
  
  products <- reactive({
    Pricemax <- as.numeric(input$pricemax)
    Pricemin <- as.numeric(input$pricemin)
    Salesrankmax <- as.numeric(input$salesrankmax)
    Salesrankmin <- as.numeric(input$salesrankmin)
    
    m <- amazon %>%
      filter(
        price >= Pricemin,
        price <= Pricemax,
        salesrank >= Salesrankmin,
        salesrank <= Salesrankmax
      ) 

      m<-as.data.frame(m)
      
  })
  


product_tooltip <- function(x) {
  if (is.null(x)) return(NULL)
  if (is.null(x$asin)) return(NULL)
  
  # Pick out the product with this ID
  amazon <- isolate(products())
  product <- amazon[amazon$asin == x$asin, ]
  
  paste0("<b><a href='",product$imUrl,"'>", product$title, "</a></b><br>",
         product$brand, "<br>",
         "$", format(product$price, big.mark = ",", scientific = FALSE),"<br>",
         product$salesrank)
}
  
  
  vis <- reactive({
    products %>%
      ggvis(x = ~price, y = ~salesrank) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   key := ~asin) %>%
      add_tooltip(product_tooltip, "click") %>%
      add_axis("x", title = c('price')) %>%
      add_axis("y", title = c('salesrank')) %>%
      set_options(width = 500, height = 500)
  })
  
  
  vis %>% bind_shiny("plot1")
  
  output$n_products <- renderText({ nrow(products()) })
}