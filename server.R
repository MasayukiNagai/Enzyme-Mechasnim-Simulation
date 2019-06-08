library(shiny)

source("repeat_simulation.R")
source("rep_plot.R")

server = function(input, output) {
    
    spectrum = reactive({
        out = repeat_simulation(reps = input$reps,
                                e = input$e,
                                s = input$s,
                                es = input$es,
                                p = input$p,
                                prob_a = input$prob_a,
                                prob_b = input$prob_b,
                                prob_c = input$prob_c,
                                cycles = input$cycles)
        out
    })
    
    output$graph = renderPlot({
        rep_plot(file = spectrum())
    })
}
