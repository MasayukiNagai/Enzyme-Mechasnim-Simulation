library(shiny)
library(shinythemes)

ui<-fluidPage(
  theme = shinytheme("flatly"),
              navbarPage("Enzyme Mechanism Simulation",
                         tabPanel("About",
                                  titlePanel("Enzyme Kinetics Simulation"),
                                  fluidRow(column(12,
                                                  align = "center",
                                                  htmlOutput("about")))
                                  ),
                         
                         tabPanel("Exercise 1",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             htmlOutput("substrate1"),
                                             HTML("<br>"),
                                             checkboxGroupInput("e1", "Enzyme concentration (μM)", 
                                                                choices = c("0.1x μM" = 0.1, "0.01x μM" = 0.01, "0.001x μM" = 0.001, "0.0001x μM" = 0.0001),
                                                                selected = c(0.1, 0.01, 0.001, 0.0001)),
                                             sliderInput("time1", "Time (s)",
                                                         min = 1, max = 500, value = 300)
                                           )),
                                    column(9,
                                           plotOutput("graph_Pt1", height = "500px")
                                    )
                                  ),
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             selectInput("e", "Determine enzyme concentration (M)",
                                                         choices = list("0.1x μM" = 10, "0.01x μM" = 0.01, "0.001x μM" = 0.001, "0.0001x μM" = 0.0001),
                                                         selected = 0.01),
                                             sliderInput("time", "Determine how long you conduct the experiment (s)",
                                                         min = 1, max = 500, value = 120)
                                           )
                                    ),
                                    column(9,
                                           wellPanel(htmlOutput("instruction_1")))
                                  )
                         ),
                         
                         tabPanel("Exercise 2",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             htmlOutput("enzyme2"),
                                             HTML("<br>"),
                                             sliderInput("s2", "Substrate Concentration (μM)",
                                                         min = 0, max = 10, value = 1, step = 0.1),
                                             actionButton("add_s2", "Do an experiment"),
                                             actionButton("reset2", "Reset Ex2")
                                           ),
                                           wellPanel(tableOutput("table2"))
                                    ),
                                    column(9,
                                           plotOutput("graph_Pt2", height = "800px")
                                           # wellPanel(htmlOutput("instruction_2"))
                                    )
                                  )
                          ),
                         
                         tabPanel("Exercise 3",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             htmlOutput("enzyme3"),
                                             HTML("<br>"),
                                             sliderInput("s3", "Substrate Concentration (μM)",
                                                         min = 0, max = 10, value = 1, step = 0.1),
                                             actionButton("add_s3", "Do an experiment"),
                                             actionButton("reset3", "Reset Ex3")
                                           ),
                                           wellPanel(tableOutput("table3"))
                                    ),
                                    column(9,
                                           plotOutput("graph_MM3", height = "800px")
                                           # wellPanel(htmlOutput("instruction_3"))
                                    )
                                  )
                              
                         ),
                         
                         tabPanel("Exercise 4",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             htmlOutput("enzyme4"),
                                             HTML("<br>"),
                                             sliderInput("km4", "Km[μM]",
                                                         min = 0, max = 10, value = 2, step = 0.01),
                                             sliderInput("vmax4", "Vmax [μM/s]",
                                                         min = 0, max = 2 , value = 0.5, step = 0.01),
                                             htmlOutput("error4"),
                                             # checkboxInput("theory4", "Display Theoretical Values"),
                                             checkboxInput("calculated4", "Display Calculated Values")
                                           ),
                                           wellPanel(tableOutput("table4"))
                                    ),
                                    column(9,
                                           plotOutput("graph_MM4", height = "800px")
                                           # wellPanel(htmlOutput("instruction_4"))
                                    )
                                  )
                         )
   )
)
