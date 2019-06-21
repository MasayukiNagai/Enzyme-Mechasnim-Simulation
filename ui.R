library(shiny)
library(shinythemes)

ui<-fluidPage(
  theme = shinytheme("flatly"),
              navbarPage("Enzyme Mechanism Simulation",
                             tabPanel("Basic Reaction",
                                      sidebarPanel(
                                          sliderInput("e", "E:",
                                                      min = 0, max = 100, value = 10),
                                          sliderInput("s", "S:",
                                                      min = 0, max = 1000, value = 300),
                                          sliderInput("prob_a", "Probality of A",
                                                      min = 0, max = 100, value = 100),
                                          sliderInput("prob_b", "Probality of B",
                                                      min = 0, max = 100, value = 20),
                                          sliderInput("prob_c", "Probality of C",
                                                      min = 0, max = 100, value = 5),
                                          sliderInput("cycles", "Time",
                                                      min = 0, max = 100000, value = 1000),
                                          sliderInput("reps", "Repeats",
                                                      min = 0, max = 100, value = 10),
                                          checkboxGroupInput("display", "Display: ",
                                                             c("E" = 1, "S" = 2, "ES" = 3, "P" = 4), selected = c(2,3,4), inline = TRUE)

                                      ),
                                      mainPanel(
                                          plotOutput("graph", height = "600px"))
                                      ),

                              tabPanel("Michaelis-Menten Equation",
                                      sidebarPanel(
                                          sliderInput("e_MM", "E:",
                                                      min = 0, max = 100, value = 10),
                                          sliderInput("s_MM", "S:",
                                                      min = 0, max = 1000, value = 300),
                                          sliderInput("k1", "k1",
                                                      min = 0, max = 100, value = 100),
                                          sliderInput("k_1", "k-1",
                                                      min = 0, max = 100, value = 20),
                                          sliderInput("k2", "k2",
                                                      min = 0, max = 100, value = 5),
                                          sliderInput("time", "time",
                                                      min = 0, max = 1000, value = 500)
                                      ),
                                      mainPanel(
                                        plotOutput("graph_MM", height = "600px"))
                                      ),
                         tabPanel("Michaelis-Menten with Inhibitors",
                                  sidebarPanel(
                                    sliderInput("e_MMI", "E: ",
                                                min = 0, max = 100, value = 10),
                                    sliderInput("s_MMI", "S: ",
                                                min = 0, max = 1000, value = 300),
                                    sliderInput("i_MMI", "I: ",
                                                min = 0, max = 1000, value = 100),
                                    sliderInput("k1", "k1",
                                                min = 0, max = 100, value = 100),
                                    sliderInput("k_1", "k_1",
                                                min = 0, max = 100, value = 20),
                                    sliderInput("k2", "k2",
                                                min = 0, max = 100, value = 5),
                                    sliderInput("k3", "k3",
                                                min = 0, max = 100, value = 15),
                                    sliderInput("k_3", "k_3",
                                                min = 0, max = 100, value = 15)
                                  ),
                                  mainPanel(
                                    plotOutput("graph_MMI", height = "600px"))
                         ),
                         
                         tabPanel("Michaelis-Menten Experiments",
                                  sidebarPanel(
                                    sliderInput("s_ex", "S (μM)",
                                                min = 0, max = 10, value = 1, step = 0.5),
                                    sliderInput("e_ex", "E (μM)",
                                                min = 0, max = 0.10, value = 0.02, step = 0.01),
                                    sliderInput("k1_ex", "k1 (/(μM*s))",
                                                min = 0, max = 2000, value = 1000),
                                    sliderInput("k_1_ex", "k_1 (/s)",
                                                min = 0, max = 2000, value = 950),
                                    sliderInput("k2_ex", "k2 (/s)",
                                                min = 0, max = 100, value = 50),
                                    sliderInput("time_ex", "Time (s)",
                                                min = 0, max = 100, value = 30),
                                    actionButton("initial_button", "Decide Initinal States"),
                                    actionButton("upgrade_button", "Upgrade S"),
                                    checkboxInput("theory", "Display Theoretical Values", value = FALSE)
                                    
                                  ),
                                  mainPanel(
                                    plotOutput("graph_P", height = "400px"),
                                    plotOutput("graph_EX", height = "400px"))
                                  )
                             
                         
   )
)
