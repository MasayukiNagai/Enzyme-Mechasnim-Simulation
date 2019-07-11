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
                         tabPanel("Overview",
                                  sidebarPanel(
                                    width = 3,
                                    selectInput("e0", "[E] (M)",
                                                choices = list("100 μM" = 100 * 10^(-6), "10 μM" = 10 * 10^(-6)),
                                                selected = 2 * 10^(-2)),
                                    sliderInput("s0", "S (M)",
                                                min = 0, max = 10, value = 1, step = 0.01),
                                    actionButton("add_s0", "Do an experiment"),
                                    sliderInput("time0", "Time (s)",
                                                min = 0, max = 10000, value = 1000, step = 10),
                                    hr(),
                                    checkboxInput("fit0", "Predict values (blue)", value = FALSE),
                                    sliderInput("km0", "Km[M]",
                                                min = 0, max = 10, value = 2, step = 0.01),
                                    sliderInput("vmax0", "Vmax [M/s]",
                                                min = 0, max = 0.01 , value = 0.01, step = 0.0001),
                                    verbatimTextOutput("error0"),
                                    checkboxInput("theory0", "Display theoretical values (red)", value = FALSE),
                                    verbatimTextOutput("theory_values0")
                                  ),
                                  mainPanel(
                                    plotOutput("graph_Pt0", height = "400px"),
                                    plotOutput("graph_MM0", height = "400px"))
                         ),
                         
                         tabPanel("Exercise 1",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             selectInput("e1", "Enzyme concentration (M)",
                                                         choices = list("1.0 M" = 1, "0.1 M" = 0.1, "100 μM" = 100 * 10^(-6), "10 μM" = 10 * 10^(-6)),
                                                         selected = NULL),
                                             selectInput("s1", "Substrate concentration (M)",
                                                         choices = list("0.5 M" = 0.5, "1.0 M" = 1, "3.0 M" = 3, "7.0 M" = 7, "10.0 M" = 10),
                                                         selected = NULL),
                                             actionButton("ex1", "Do an experiment")
                                           )),
                                    column(9,
                                           plotOutput("graph_Pt1", height = "500px")
                                    )
                                  ),
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             selectInput("e", "Determine enzyme concentration (M)",
                                                         choices = list("1.0 M" = 1, "0.1 M" = 0.1, "100 μM" = 100 * 10^(-6), "10 μM" = 10 * 10^(-6)),
                                                         selected = NULL)
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
                                             h5("Enzyme concentration from exercise 1"),
                                             verbatimTextOutput("enzyme2"),
                                             sliderInput("s2", "Substrate Concentration (M)",
                                                         min = 0, max = 10, value = 1, step = 0.01),
                                             actionButton("add_s2", "Do an experiment")
                                           )),
                                    column(9,
                                           plotOutput("graph_Pt2", height = "500px")
                                    )
                                  ),
                                  fluidRow(
                                    column(3, align = "center",
                                           wellPanel(tableOutput("table2"))
                                           ),
                                    column(9, 
                                           wellPanel(htmlOutput("instruction_2")))
                                  )
                          ),
                         
                         tabPanel("Exercise 3",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             h5("Enzyme concentration from exercise 1"),
                                             verbatimTextOutput("enzyme3"),
                                             sliderInput("s3", "Substrate Concentration (M)",
                                                         min = 0, max = 10, value = 1, step = 0.01),
                                             actionButton("add_s3", "Do an experiment")
                                           )),
                                    column(9,
                                           plotOutput("graph_MM3", height = "500px")
                                    )
                                  ),
                                  fluidRow(
                                    column(3, align = "center",
                                           wellPanel(tableOutput("table3"))
                                    ),
                                    column(9, 
                                           wellPanel(htmlOutput("instruction_3")))
                                  )
                         ),
                         
                         tabPanel("Exercise 4",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             h5("Enzyme concentration from exercise 1"),
                                             verbatimTextOutput("enzyme4"),
                                             sliderInput("km4", "Km[M]",
                                                         min = 0, max = 10, value = 2, step = 0.01),
                                             sliderInput("vmax4", "Vmax [M/s]",
                                                         min = 0, max = 0.01 , value = 0.01, step = 0.0001),
                                             verbatimTextOutput("error4"),
                                             checkboxInput("theory4", "Display Theoretical Values")
                                           )),
                                    column(9,
                                           plotOutput("graph_MM4", height = "500px")
                                    )
                                  ),
                                  fluidRow(
                                    column(3, align = "center",
                                           wellPanel(tableOutput("table4"))
                                    ),
                                    column(9, 
                                           wellPanel(htmlOutput("instruction_4")))
                                  )
                         )
              
   )
)
