#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)


# ui object
ui <- fluidPage(
  titlePanel(p("Spatial app", style = "color:#3474A7")),
  sidebarLayout(
    sidebarPanel(
      p("Made with", a("Shiny",
                       href = "http://shiny.rstudio.com"
      ), "."),
      img(
        src = "imageShiny.png",
        width = "70px", height = "70px"
      )
    ),
    mainPanel("main panel for outputs")
  )
)

# server()
server <- function(input, output) { }

# shinyApp()
shinyApp(ui = ui, server = server)