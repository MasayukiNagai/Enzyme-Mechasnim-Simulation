library(shiny)
library(VGAM)
library(stats4)
library(splines)

source("lambertMM.R")
source("lambertMMsd.R")
source("plot_lambert.R")
source("plot_lambert2.R")
source("plot_lambertMM.R")
source("calc_slopes.R")

server = function(input, output, session) {

    #page 1
    substrates = character()
    values = reactiveValues(df = data.frame("substrates" = substrates))
    newEntry = observeEvent(input$upgrade_button, {
        substrates_new = c(values$df$substrates, input$s)
        values$df = data.frame("substrates" = substrates_new)
    })

    spectrum = reactive({
        out = lambertMM(file = values$df,
                        "e" = input$e * 10^(-6),
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
    
    #Page2 P-t graph 1
    output$instruction_Pt = renderUI({
        includeHTML("instruction_Pt.html")
    })
    
    substrates_1 = character()
    slopes_1 = character()
    values_1 = reactiveValues(df = data.frame("substrates" = substrates_1, "slopes" = slopes_1))
    newEntry = observeEvent(input$add_s_1, {
        if(input$s_1 %in% values_1$df$substrates){
            substrates_new = values_1$df$substrates
        }
        else{
            substrates_new = c(values_1$df$substrates, input$s_1)
        }
        e = as.numeric(input$e_1)
        time = input$time_1
        slopes_new = unlist(lapply(substrates_new, calc_slopes, "e" = e, "time" = time))
        if(e == 1 * 10^(-1) || e == 2 * 10^(-2)){
            values_1$df = data.frame("substrates" = substrates_new, "slopes" = formatC(slopes_new, format = "f", digits = 3))
        }
        else{
            values_1$df = data.frame("substrates" = substrates_new, "slopes" = formatC(slopes_new, format = "e", digits = 2))
        }
        
    })
    
    observe({
        concentration = as.numeric(input$e_1)
        if(concentration == 1 * 10^(-1)){
            fixed_time = 10
        }
        else if(concentration == 2 * 10^(-2)){
            fixed_time = 20
        }
        else if(concentration == 1 * 10^(-4)){
            fixed_time = 4000
        }
        else if(concentration == 1 * 10^(-5)){
            fixed_time = 10000
        }
        else{
            fixed_time = 100
        }
        updateSliderInput(session, "time_1", value = fixed_time)
    })
    
    spectrum_1 = reactive({
        out = lambertMM(file = values_1$df,
                        "e" = as.numeric(input$e_1),
                        # "km" = input$km_1,
                        # "k2" = input$k2_1,
                        "time" = input$time_1)
    })
    
    output$graph_Pt_1 = renderPlot({
        plot_lambert2(file = spectrum_1(),
                     display_theoretical_values = input$theory_1)
    })
    
    output$table_Pt_1 = renderTable({
        if(length(values_1$df$substrates) < 10 && length(values_1$df$substrates) > 0){
            values_1$df[1:length(values_1$df$substrates), c("substrates", "slopes")]
        }
        else if (length(values_1$df$substrates) > 10){
            values_1$df[1:10,c("substrates", "slopes")]
        }
        else{
            values_1$df
        }
    }, striped = TRUE, bordered = TRUE, align = "c", width = "200px" )
    
    #Page3 P-t graph 1
    output$instruction_Pt_2 = renderUI({
        includeHTML("instruction_Pt.html")
    })
    substrates_2 = character()
    slopes_2 = character()
    values_2 = reactiveValues(df = data.frame("substrates" = substrates_2, "slopes" = slopes_2))
    newEntry = observeEvent(input$add_s_2, {
        if(input$s_2 %in% values_2$df$substrates){
            substrates_new = values_2$df$substrates
        }
        else{
            substrates_new = c(values_2$df$substrates, input$s_2)
        }
        e = as.numeric(input$e_2)
        time = input$time_2
        slopes_new = unlist(lapply(substrates_new, calc_slopes, "e" = e, "time" = time))
        if(e == 1 * 10^(-1) || e == 2 * 10^(-2)){
            values_2$df = data.frame("substrates" = substrates_new, "slopes" = formatC(slopes_new, format = "f", digits = 3))
        }
        else{
            values_2$df = data.frame("substrates" = substrates_new, "slopes" = formatC(slopes_new, format = "e", digits = 2))
        }

    })

    observe({
        concentration = as.numeric(input$e_2)
        if(concentration == 1 * 10^(-1)){
            fixed_time = 10
        }
        else if(concentration == 2 * 10^(-2)){
            fixed_time = 20
        }
        else if(concentration == 1 * 10^(-4)){
            fixed_time = 4000
        }
        else if(concentration == 1 * 10^(-5)){
            fixed_time = 10000
        }
        else{
            fixed_time = 100
        }
        updateSliderInput(session, "time_2", value = fixed_time)
    })

    spectrum_2 = reactive({
        out = lambertMM(file = values_2$df,
                        "e" = as.numeric(input$e_2),
                        "time" = input$time_2)
    })

    output$graph_Pt_2 = renderPlot({
        plot_lambert2(file = spectrum_2(),
                      display_theoretical_values = input$theory_2)
    })

    output$table_Pt_2 = renderTable({
        if(length(values_2$df$substrates) < 10 && length(values_2$df$substrates) > 0){
            values_2$df[1:length(values_2$df$substrates), c("substrates", "slopes")]
        }
        else if (length(values_2$df$substrates) > 10){
            values_2$df[1:10,c("substrates", "slopes")]
        }
        else{
            values_2$df
        }
    }, striped = TRUE, bordered = TRUE, align = "c", width = 300 )
    
    #Page 4 P-t and MM 1
    substrates_3 = character()
    values_3 = reactiveValues(df = data.frame("substrates" = substrates_3))
    newEntry = observeEvent(input$add_s_3, {
        substrates_new = c(values_3$df$substrates, input$s_3)
        values_3$df = data.frame("substrates" = substrates_new)
    })
    
    spectrum_3 = reactive({
        out = lambertMM(file = values_3$df,
                         "e" = as.numeric(input$e_3),
                         "time" = input$time_3,
                         "sd" = 0)
    })
    
    output$graph_Pt_3 = renderPlot({
        plot_lambert2(file = spectrum_3(),
                      display_theoretical_values = input$theory_3)
    })
    
    output$graph_MM_3 = renderPlot({
        plot_lambertMM(file = spectrum_3(),
                        display_theoretical_values = input$theory_3)
    })
}
