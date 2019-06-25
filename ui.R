library(shiny)
library(shinythemes)

ui<-fluidPage(
  theme = shinytheme("flatly"),
              navbarPage("Enzyme Mechanism Simulation",
                             tabPanel("Michaelis-Menten Simulation",
                                  sidebarPanel(
                                    selectInput("games","Type of Reaction: ",
                                                choices = list("Normal", "Competitive", "Uncompetitive", "Mixed"), 
                                                selected = "Normal"),
                                    sliderInput("s", "S (M)",
                                                min = 0, max = 10, value = 1, step = 0.01),
                                    actionButton("upgrade_button", "Upgrade S"),
                                    actionButton("ds1", "Data set 1"),
                                    actionButton("ds2", "Data set 2"),
                                    sliderInput("e", "E (μM)",
                                                min = 0, max = 20000, value = 10, step = 1),
                                    sliderInput("i", "I (M)",
                                                min = 0, max = 2, value = 0, step = 0.1),
                                    sliderInput("k1", "k1 (/(M * s))",
                                                min = 0, max = 5000, value = 1000, step = 50),
                                    sliderInput("k_1", "k-1 (/s)",
                                                min = 0, max = 1000, value = 950, step = 50),
                                    sliderInput("k2", "k2 (/s)",
                                                min = 0, max = 100, value = 50),
                                    sliderInput("ki1", "ki1 (M)",
                                                min = 0, max = 1, value = 0.20),
                                    sliderInput("ki2", "ki2 (M)",
                                                min = 0, max = 1, value = 0.15),
                                    sliderInput("time", "Time (s)",
                                                min = 0, max = 1000, value = 20, step = 1),
                                    sliderInput("sd", "Deviation",
                                                min = 0, max = 0.2, value = 0, step = 0.05),
                                    checkboxInput("theory", "Display Theoretical Values", value = FALSE)
                                    
                                  ),
                                  mainPanel(
                                    plotOutput("graph_P", height = "400px"),
                                    plotOutput("graph_MM", height = "400px"))
                                  )
                             
                         
   )
)
