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
                                                      min = 0, max = 100, value = 5)
                                      ),
                                      mainPanel(
                                        plotOutput("graph_MM", height = "600px"))
                                      )
   )
)
