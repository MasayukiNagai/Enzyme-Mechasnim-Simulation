library(shiny)

shinyUI(fluidPage(

    titlePanel("Enzyme Mechanism Simulation"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("e", "E:",
                        min = 0, max = 300, value = 50),
            sliderInput("s", "S:",
                        min = 0, max = 300, value = 150),
            sliderInput("es", "ES:",
                        min = 0, max = 150, value = 0),
            sliderInput("p", "P:",
                        min = 0, max = 300, value = 0),
            sliderInput("prob_a", "Probality of A",
                        min = 0, max = 100, value = 80),
            sliderInput("prob_b", "Probality of B",
                        min = 0, max = 100, value = 50),
            sliderInput("prob_c", "Probality of C",
                        min = 0, max = 100, value = 5),
            sliderInput("cycles", "Time",
                        min = 0, max = 10000, value = 3000),
            sliderInput("reps", "Repeats",
                        min = 0, max = 100, value = 10)
        ),

        mainPanel(
            plotOutput("graph", height = "600px")
        )
    )
))
