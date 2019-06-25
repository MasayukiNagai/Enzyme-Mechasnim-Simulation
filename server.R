library(shiny)
library(VGAM)
library(stats4)
library(splines)

source("lambertMM.R")
source("plot_lambert.R")
source("plot_lambertMM.R")

server = function(input, output, session) {

    substrates = character()
    values = reactiveValues(df = data.frame("substrates" = substrates))
    newEntry = observeEvent(input$upgrade_button, {
        substrates_new = c(values$df$substrates, input$s)
        values$df = data.frame("substrates" = substrates_new)
    })

    spectrum = reactive({
        out = lambertMM(file = values$df,
                        "e" = input$e,
                        "i" = input$i,
                        "k1" = input$k1,
                        "k_1" = input$k_1,
                        "k2" = input$k2,
                        "ki1" = input$ki1,
                        "ki2" = input$ki2,
                        "time" = input$time,
                        "sd" = input$sd,
                        "game" = input$games)
        out
    })
    
    observeEvent(input$ds1,{
        updateSliderInput(session, "e", value = 20000)
        updateSliderInput(session, "k1", value = 1000)
        updateSliderInput(session, "k_1", value = 950)
        updateSliderInput(session, "k2", value = 50)
    })
    
    observeEvent(input$ds2,{
        updateSliderInput(session, "e", value = 10)
        updateSliderInput(session, "k1", value = 3500)
        updateSliderInput(session, "k_1", value = 150)
        updateSliderInput(session, "k2", value = 2)
        updateSliderInput(session, "time", value = 1000)
    })
    
    
    output$graph_P = renderPlot({
        plot_lambert(file = spectrum(),
                     display_theoretical_values = input$theory)
    })
    
    output$graph_MM = renderPlot({
        plot_lambertMM(file = spectrum(),
                       display_theoretical_values = input$theory)
    })
}
