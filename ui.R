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
                                  ),
                         
                         
                         tabPanel("P-t Graph 2",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             selectInput("e_2", "[E] (M)",
                                                         choices = list("0.1 M" = 1 * 10^(-1), "0.02 M" = 2 * 10^(-2), "100 μM" = 100 * 10^(-6), "10 μM" = 10 * 10^(-6)),
                                                         selected = 100 * 10^(-6)),
                                             sliderInput("s_2", "[S] (M)",
                                                         min = 0, max = 10, value = 1, step = 0.01),
                                             actionButton("add_s_2", "Do an experiment"),
                                             sliderInput("time_2", "Time(s)",
                                                         min = 1, max = 10000, value = 20, step = 10),
                                             checkboxInput("theory_2", "Display Theoretical Values", value = FALSE)
                                           )
                                           ),
                                    column(8,
                                           plotOutput("graph_Pt_2", height = "500px")
                                           )
                                  ),
                                    fluidRow(
                                      column(3, align = "center",
                                             wellPanel(tableOutput("table_Pt_2"), style = "background: lightgrey")
                                             
                                      ),
                                      column(8,
                                             htmlOutput("instruction_Pt_2")
                                      )
                                    )
                                  ),
                         
                         tabPanel("P-t and MM 2",
                                  sidebarPanel(
                                    width = 3,
                                    selectInput("e_4", "[E] (M)",
                                                choices = list("100 μM" = 100 * 10^(-6), "10 μM" = 10 * 10^(-6)),
                                                selected = 2 * 10^(-2)),
                                    sliderInput("s_4", "S (M)",
                                                min = 0, max = 10, value = 1, step = 0.01),
                                    actionButton("add_s_4", "Do an experiment"),
                                    sliderInput("time_4", "Time (s)",
                                                min = 0, max = 1000, value = 1000, step = 1),
                                    hr(),
                                    checkboxInput("fit_4", "Predict values (blue)", value = FALSE),
                                    sliderInput("km_4", "Km[M]",
                                                min = 0, max = 10, value = 2, step = 0.01),
                                    sliderInput("vmax_4", "Vmax [M/s]",
                                                min = 0, max = 0.01 , value = 0.01, step = 0.0001),
                                    verbatimTextOutput("error_4"),
                                    checkboxInput("theory_4", "Display theoretical values (red)", value = FALSE),
                                    verbatimTextOutput("theory_values")
                                  ),
                                  mainPanel(
                                    plotOutput("graph_Pt_4", height = "400px"),
                                    plotOutput("graph_MM_4", height = "400px"))
                         ),
                         
                         tabPanel("Exercise 1",
                                  fluidRow(
                                    column(3,
                                           wellPanel(
                                             selectInput("e_1", "Enzyme concentration (M)",
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
                                             selectInput("e1", "Determine enzyme concentration (M)",
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
