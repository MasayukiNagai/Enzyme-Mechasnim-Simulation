library(shiny)

source("repeat_simulation.R")
source("rep_plot.R")
source("simulateMM.R")
source("plotMM.R")

server = function(input, output) {
    
    spectrum = reactive({
        out = repeat_simulation(reps = input$reps,
                                e = input$e,
                                s = input$s,
                                prob_a = input$prob_a,
                                prob_b = input$prob_b,
                                prob_c = input$prob_c,
                                cycles = input$cycles)
        out
    })
    
    spectrum_MM = reactive({
        out = simulateMM(e = input$e_MM,
                         s_axis = input$s_MM,
                         k1 = input$k1,
                         k_1 = input$k_1,
                         k2 = input$k2)
        out
    })
    
    output$graph = renderPlot({
        rep_plot(file = spectrum(),
                 e_average_display = 1 %in% input$display,
                 s_average_display = 2 %in% input$display,
                 es_average_display = 3 %in% input$display,
                 p_average_display = 4 %in% input$display)
    })
    
    output$graph_MM = renderPlot({
        plotMM(file = spectrum_MM())
    })
}
