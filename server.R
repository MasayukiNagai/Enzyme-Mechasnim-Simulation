library(shiny)
library(VGAM)
library(stats4)
library(splines)

source("repeat_simulation.R")
source("rep_plot.R")
source("simulateMM.R")
source("plotMM.R")
source("simulateMMwithI.R")
source("lambertMM.R")
source("plot_lambert.R")
source("plot_lambertMM.R")

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
    
    spectrum_MMI = reactive({
        out = simulateMMwithI(e = input$e_MMI,
                              s_axis = input$s_MMI,
                              i = input$i_MMI,
                              k1 = input$k1,
                              k_1 = input$k_1,
                              k2 = input$k2,
                              k3 = input$k3,
                              k_3 = input$k_3)
        out
    })
    
    substrates = character()
    values = reactiveValues(df = data.frame("substrates" = substrates))
    newEntry = observeEvent(input$upgrade_button, {
        substrates_new = c(values$df$substrates, input$s_ex)
        values$df = data.frame("substrates" = substrates_new)
    })
    
    spectrum_EX = reactive({
        out = lambertMM(file = values$df,
                        "e" = input$e_ex,
                        "i" = input$i_ex,
                        "k1" = input$k1_ex,
                        "k_1" = input$k_1_ex,
                        "k2" = input$k2_ex,
                        "ki1" = input$ki1_ex,
                        "ki2" = input$ki2_ex,
                        "time" = input$time_ex,
                        "sd" = input$sd_ex,
                        "game" = input$games)
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

    output$graph_MMI = renderPlot({
        plotMM(file = spectrum_MMI())
    })
    
    output$graph_P = renderPlot({
        plot_lambert(file = spectrum_EX(),
                     display_theoretical_values = input$theory)
    })
    
    output$graph_EX = renderPlot({
        plot_lambertMM(file = spectrum_EX(),
                       display_theoretical_values = input$theory)
    })
}
