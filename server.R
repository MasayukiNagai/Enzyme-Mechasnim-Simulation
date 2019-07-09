library(shiny)
library(VGAM)
library(stats4)
library(splines)

source("lambertMM.R")
source("lambertMMsd.R")
source("plot_lambert.R")
source("plot_lambertMM.R")
source("plot_Pt.R")
source("plot_MM.R")
source("calc_slopes.R")
source("calc_pt.R")
source("lambertPt.R")

km = 1
k2 = 50
pinf_ratio = 0.9818
sd = 0.03
s_max = 10
time_max = 10000

server = function(input, output, session) {

#page 1
    substrates_1 = character()
    values_1 = reactiveValues(df = data.frame("substrates" = substrates_1))
    newEntry = observeEvent(input$upgrade_button, {
        substrates_new = c(values_1$df$substrates, input$s)
        values_1$df = data.frame("substrates" = substrates_new)
    })

    spectrum = reactive({
        out = lambertMM(file = values_1$df,
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
    
#Page2 P-t graph 2

    output$instruction_Pt_2 = renderUI({
        includeHTML("instruction_Pt.html")
    })
    
    substrates = rep(NA, 40)
    pt = matrix(nrow = 40, ncol = time_max + 1)
    pt_error = matrix(nrow = 40, ncol = time_max + 1)
    slopes = rep(NA, 40)
    intercepts = rep(NA, 40)
    count = 0
    values = reactiveValues(df = data.frame("substrates" = substrates, "slopes" = slopes, "intercepts" = intercepts, "pt_error" = pt_error, "pt" = pt))
    newEntry = observeEvent(input$add_s_2, {
        if(!(input$s_2 %in% values$df$substrates)){
            count = length(values$df$substrates[!is.na(values$df$substrates)]) + 1
            e_2 = as.numeric(input$e_2)
            time = input$time_2
            file = lambertPt("s" = input$s_2, "e" = e_2, "time" = time, "k2" = k2, "km" = km, "pinf_ratio" = pinf_ratio, "sd" = sd)
            values$df$substrates[count] = input$s_2
            values$df[count, (5 + time_max) : (5 + time_max + time)]= file$pt
            values$df[count, 4 : (4 + time)] = file$pt_error
            if(e_2 == 1 * 10^(-1) || e_2 == 2 * 10^(-2)){
                values$df$slopes[count] = formatC(file$slopes_error, format = "f", digits = 3)
            }
            else{
                values$df$slopes[count] = formatC(file$slopes_error, format = "e", digits = 3)
            }
            values$df$intercepts[count] = file$intercepts_error
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

    output$graph_Pt_2 = renderPlot({
        plot_Pt(file = values$df,
                "time" = input$time_2,
                "s_max" = s_max,
                "pinf_ratio" = pinf_ratio,
                "kmapp" = km,
                display_theoretical_values = input$theory_2)
    })

    
    output$table_Pt_2 = renderTable({
        if(length(which(values$df$substrates >=0)) < 10 && length(which(values$df$substrates >=0)) > 0){
            values$df[1: length(which(values$df$substrates >=0)), c("substrates", "slopes")]
        }
        else if (length(which(values$df$substrates >=0)) >= 10){
            values$df[1:10, c("substrates", "slopes")]
        }
        else{
            values$df[1, c("substrates", "slopes")]
        }
    }, striped = TRUE, bordered = TRUE, align = "c", width = 300)
    
    
#Page 3 P-t and MM 2
    substrates_4 = character()
    values_4 = reactiveValues(df = data.frame("substrates" = substrates_4))
    newEntry = observeEvent(input$add_s_4, {
        substrates_new = c(values_4$df$substrates, input$s_4)
        values_4$df = data.frame("substrates" = substrates_new)
    })
    
    observe({
        concentration = as.numeric(input$e_4)
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
        updateSliderInput(session, "time_3", value = fixed_time)
    })
    
    
    spectrum_4 = reactive({
        out = lambertMM(file = values_4$df,
                        "e" = as.numeric(input$e_4),
                        "s_max" = 10,
                        "time" = input$time_4,
                        "km" = 1,
                        "sd" = 0.03,
                        "km_pre" = input$km_4,
                        "vmax_pre" = input$vmax_4)
    })
    
    output$graph_Pt_4 = renderPlot({
        plot_lambert(file = spectrum_4(),
                      display_theoretical_values = input$theory_4)
    })
    
    output$graph_MM_4 = renderPlot({
        plot_lambertMM(file = spectrum_4(),
                       display_theoretical_values = input$theory_4,
                       display_fit_values = input$fit_4)
    })
    
    output$error_4 = renderText({
        error = round(spectrum_4()$error,2)
        paste("Error:", error)
    })
    
    output$theory_values = renderText({
        file =  spectrum_4()
        km = file$kmapp
        vmax = file$vapp
        paste("Theorectical values")
        if(input$theory_4){
            paste("Km:", km, ",", "Vmax:", vmax)
        }
        else{
            paste("Km:", " ", ",",  "Vmax:", " ")
        }
    })
    
# Exercise 2
    output$enzyme2 = renderText({
        paste("100 μM")
    })
    
    output$instruction_2 = renderUI({
        includeHTML("instruction_Pt.html")
    })
    
    substrates2 = rep(NA, 20)
    pt2 = matrix(nrow = 20, ncol = time_max + 1)
    pt_error2 = matrix(nrow = 20, ncol = time_max + 1)
    slopes2 = rep(NA, 20)
    intercepts2 = rep(NA, 20)
    #e2 and time are determined by excercise 1
    e2 = 100 * 10^(-6)
    time2 = 4000
    values2 = reactiveValues(df = data.frame("substrates" = substrates2, "slopes" = slopes2, "intercepts" = intercepts2, "pt_error" = pt_error2, "pt" = pt2))
    newEntry2 = observeEvent(input$add_s2, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        if(!(input$s2 %in% values2$df$substrates) && count < 5){
            file = lambertPt("s" = input$s2, "e" = e2, "time" = time2, "k2" = k2, "km" = km, "pinf_ratio" = pinf_ratio, "sd" = sd)
            values2$df$substrates[(count + 1)] = input$s2
            values2$df[(count + 1), (5 + time_max) : (5 + time_max + time2)]= file$pt
            values2$df[(count + 1), 4 : (4 + time2)] = file$pt_error
            values2$df$slopes[(count + 1)] = formatC(file$slopes_error, format = "e", digits = 3)
            values2$df$intercepts[(count + 1)] = file$intercepts_error
        } 
    })

    output$graph_Pt2 = renderPlot({
        plot_Pt(file = values2$df,
                #time is determined from exercise 1
                "time" = 4000,
                "s_max" = s_max,
                "pinf_ratio" = pinf_ratio,
                "kmapp" = km)
    })
    
    output$table2 = renderTable({
        if(length(which(values2$df$substrates >=0)) < 5 && length(which(values2$df$substrates >=0)) > 0){
            values2$df[1: length(which(values2$df$substrates >=0)), c("substrates", "slopes")]
        }
        else if (length(which(values2$df$substrates >=0)) >= 5){
            values2$df[1:5, c("substrates", "slopes")]
        }
        else{
            values2$df[1, c("substrates", "slopes")]
        }
    }, striped = TRUE, bordered = TRUE, align = "c", width = 300)
    
#Exercise 3
    
    # Exercise 2
    output$enzyme3 = renderText({
        paste("100 μM")
    })
    
    output$instruction_3 = renderUI({
        includeHTML("instruction_Pt.html")
    })
    
    newEntry3 = observeEvent(input$add_s3, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        if(!(input$s3 %in% values2$df$substrates) && count < 10){
            file = lambertPt("s" = input$s3, "e" = e2, "time" = time2, "k2" = k2, "km" = km, "pinf_ratio" = pinf_ratio, "sd" = sd)
            values2$df$substrates[(count + 1)] = input$s3
            values2$df[(count + 1), (5 + time_max) : (5 + time_max + time2)]= file$pt
            values2$df[(count + 1), 4 : (4 + time2)] = file$pt_error
            values2$df$slopes[(count + 1)] = formatC(file$slopes_error, format = "e", digits = 3)
            values2$df$intercepts[(count + 1)] = file$intercepts_error
        } 
    })
    
    output$graph_MM3 = renderPlot({
        plot_MM(file = values2$df,
                #time is determined from exercise 1
                "time" = 4000,
                "s_max" = s_max,
                "pinf_ratio" = pinf_ratio,
                "kmapp" = km)
    })
    
    output$table3 = renderTable({
        if(length(which(values2$df$substrates >=0)) < 10 && length(which(values2$df$substrates >=0)) > 0){
            values2$df[1: length(which(values2$df$substrates >=0)), c("substrates", "slopes")]
        }
        else if (length(which(values2$df$substrates >=0)) >= 10){
            values2$df[1:10, c("substrates", "slopes")]
        }
        else{
            values2$df[1, c("substrates", "slopes")]
        }
    }, striped = TRUE, bordered = TRUE, align = "c", width = 300)
}
