library(shiny)
library(VGAM)
library(stats4)
library(splines)

source("plot_Pt.R")
source("plot_MM.R")
source("lambertPt.R")
source("simple_plot_Pt.R")

km = 1
k2 = 50
pinf_ratio = 0.9818
sd = 0.03
s_max = 10
time_max = 10000

server = function(input, output, session) {

#About
    output$about = renderUI({
        includeHTML("Captions/about.html")
    })
    
#Overview
    substrates0 = rep(NA, 20)
    pt0 = matrix(nrow = 20, ncol = time_max + 1)
    pt_error0 = matrix(nrow = 20, ncol = time_max + 1)
    slopes0 = rep(NA, 20)
    intercepts0 = rep(NA, 20)
    values0 = reactiveValues(df = data.frame("substrates" = substrates0, "slopes" = slopes0, "intercepts" = intercepts0, "pt_error" = pt_error0, "pt" = pt0))
    newEntry0 = observeEvent(input$add_s0, {
        count = length(values0$df$substrates[!is.na(values0$df$substrates)])
        if(!(input$s0 %in% values0$df$substrates) && count < 10){
            file = lambertPt(s = input$s0, e = as.numeric(input$e0), k2 = k2, km = km, s_max = s_max, time_max = time_max, pinf_ratio = pinf_ratio, sd = sd)
            values0$df$substrates[(count + 1)] = input$s0
            values0$df[(count + 1), (5 + time_max) : (5 + time_max + time_max)]= file$pt
            values0$df[(count + 1), 4 : (4 + time_max)] = file$pt_error
            values0$df$slopes[(count + 1)] = formatC(file$slopes_error, format = "e", digits = 3)
            values0$df$intercepts[(count + 1)] = file$intercepts_error
        } 
    })
    
    observe({
        concentration = as.numeric(input$e0)
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
        updateSliderInput(session, "time0", value = fixed_time)
    })
    
    output$graph_Pt0 = renderPlot({
        plot_Pt(file = values0$df,
                time = input$time0,
                s_max = s_max,
                time_max = time_max,
                pinf_ratio = pinf_ratio,
                kmap = km,
                display_theoretical_values = input$theory0)
    })
    
    output$graph_MM0 = renderPlot({
        plot_MM(file = values0$df,
                time = input$time0,
                s_max = s_max,
                pinf_ratio = pinf_ratio,
                kmapp = km,
                km_pre = input$km0,
                vmax_pre = input$vmax0,
                display_theoretical_values = input$theory0,
                display_fit_values = input$fit0)
    })
    
    #should use kmapp but now just using km
    output$error0 = renderText({
        vmax0 = k2 * as.numeric(input$e0)
        count = length(values0$df$substrates[!is.na(values0$df$substrates)])
        theo = vmax0 * as.numeric(values0$df$substrates[1:count])/(km + as.numeric(values0$df$substrates[1:count]))
        exp = input$vmax0 * as.numeric(values0$df$substrates[1:count])/(input$km0 + as.numeric(values0$df$substrates[1:count]))
        error = round(sum(sqrt((theo - exp)^2))/as.numeric(input$e0), 2)
        paste("<b>Error: ", error, "</b>")
    })
    
    output$theory_values0 = renderText({
        paste("Theorectical values")
        vmax0 = k2 * as.numeric(input$e0)
        if(input$theory0){
            paste("Km:", km, ",", "Vmax:", vmax0)
        }
        else{
            paste("Km:", " ", ",",  "Vmax:", " ")
        }
    })
    
# Exercise 1

    output$instruction_1 = renderUI({
        includeHTML("Captions/instruction_ex1.html")
    })

    calcPt = reactive({
        out = lambertPt(s = as.numeric(input$s1),
                        e = as.numeric(input$e1),
                        k2 = k2,
                        km = km,
                        s_max = s_max,
                        pinf_ratio = pinf_ratio,
                        time_max = time_max,
                        sd = sd)
        out
    })

    output$graph_Pt1 = renderPlot({
        simple_plot_Pt(file = calcPt())
    })

    
# Exercise 2
    output$enzyme2 = renderText({
        paste(input$e, " M")
    })
    
    output$instruction_2 = renderUI({
        includeHTML("Captions/instruction_ex2.html")
    })
    
    times = rep(NA, 20)
    substrates2 = rep(NA, 20)
    pt2 = matrix(nrow = 20, ncol = time_max + 1)
    pt_error2 = matrix(nrow = 20, ncol = time_max + 1)
    slopes2 = rep(NA, 20)
    intercepts2 = rep(NA, 20)
    #time should be determined by ex1
    time2 = 4000
    values2 = reactiveValues(df = data.frame("substrates" = substrates2, "slopes" = slopes2, "intercepts" = intercepts2, "pt_error" = pt_error2, "pt" = pt2, "times" = times))
    newEntry2 = observeEvent(input$add_s2, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        if(!(input$s2 %in% values2$df$substrates) && count < 5){
            file = lambertPt(s = input$s2, e = as.numeric(input$e), time = time2, k2 = k2, km = km, s_max = s_max, pinf_ratio = pinf_ratio, sd = sd)
            values2$df$substrates[(count + 1)] = input$s2
            values2$df[(count + 1), (5 + time_max) : (5 + time_max + time2)]= file$pt
            values2$df[(count + 1), 4 : (4 + time2)] = file$pt_error
            values2$df$slopes[(count + 1)] = formatC(file$slopes_error, format = "e", digits = 3)
            values2$df$intercepts[(count + 1)] = file$intercepts_error
            values2$df$times[(count + 1)] = count + 1
        } 
    })
    
    reset2 = observeEvent(input$reset2, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        values2$df[1:count, ] = NA
    })

    output$graph_Pt2 = renderPlot({
        plot_Pt(file = values2$df,
                #time is determined from exercise 1
                time = 4000,
                s_max = s_max,
                pinf_ratio = pinf_ratio,
                kmap = km)
    })
    
    output$table2 = renderTable({
        if(length(which(values2$df$substrates >=0)) < 5 && length(which(values2$df$substrates >=0)) > 0){
            values2$df[1: length(which(values2$df$substrates >=0)), c("times", "substrates", "slopes")]
        }
        else if (length(which(values2$df$substrates >=0)) >= 5){
            values2$df[1:5, c("times", "substrates", "slopes")]
        }
        else{
            values2$df[1, c("times", "substrates", "slopes")]
        }
    }, striped = TRUE, bordered = TRUE, align = "c", width = 300)

        
#Exercise 3
    output$enzyme3 = renderText({
        paste(input$e, " M")
    })
    
    output$instruction_3 = renderUI({
        includeHTML("Captions/instruction_ex3.html")
    })
    
    newEntry3 = observeEvent(input$add_s3, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        #you may want to add "count >= 5" to the following condition which restrict student from skipping ex2
        if(!(input$s3 %in% values2$df$substrates) && count < 10){
            file = lambertPt(s = input$s3, e = as.numeric(input$e), time = time2, k2 = k2, km = km, s_max = s_max, pinf_ratio = pinf_ratio, sd = sd)
            values2$df$substrates[(count + 1)] = input$s3
            values2$df[(count + 1), (5 + time_max) : (5 + time_max + time2)]= file$pt
            values2$df[(count + 1), 4 : (4 + time2)] = file$pt_error
            values2$df$slopes[(count + 1)] = formatC(file$slopes_error, format = "e", digits = 3)
            values2$df$intercepts[(count + 1)] = file$intercepts_error
            values2$df$times[(count + 1)] = count + 1
        } 
    })
    
    reset3 = observeEvent(input$reset3, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        if(count > 5){
            values2$df[5:count, ] = NA
        }
    })
    
    output$graph_MM3 = renderPlot({
        plot_MM(file = values2$df,
                #time is determined from exercise 1
                time = 4000,
                s_max = s_max,
                pinf_ratio = pinf_ratio,
                kmapp = km)
    })
    
    output$table3 = renderTable({
        if(length(which(values2$df$substrates >=0)) < 10 && length(which(values2$df$substrates >=0)) > 0){
            values2$df[1: length(which(values2$df$substrates >=0)), c("times", "substrates", "slopes")]
        }
        else if (length(which(values2$df$substrates >=0)) >= 10){
            values2$df[1:10, c("times", "substrates", "slopes")]
        }
        else{
            values2$df[1, c("times", "substrates", "slopes")]
        }
    }, striped = TRUE, bordered = TRUE, align = "c", width = 300)
    
    
#Exercise 4
    output$enzyme4 = renderText({
        paste(input$e, " M")
    })
    
    #should use kmapp but now just using km
    output$error4 = renderText({
        vmax4 = k2 * as.numeric(input$e)
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        theo = vmax4 * as.numeric(values2$df$substrates[1:count])/(km + as.numeric(values2$df$substrates[1:count]))
        exp = input$vmax4 * as.numeric(values2$df$substrates[1:count])/(input$km4 + as.numeric(values2$df$substrates[1:count]))
        error = round(sum(sqrt((theo - exp)^2))/as.numeric(input$e), 2)
        paste("<b>Error from plots: ", error, "</b>")
    })
    
    output$instruction_4 = renderUI({
        includeHTML("Captions/instruction_ex4.html")
    })
    
    output$graph_MM4 = renderPlot({
        plot_MM(file = values2$df,
                #time is determined from exercise 1
                time = 4000,
                s_max = s_max,
                pinf_ratio = pinf_ratio,
                kmapp = km,
                km_pre = input$km4,
                vmax_pre = input$vmax4,
                display_theoretical_values = input$theory4,
                display_fit_values = TRUE)
    })
    
    output$table4 = renderTable({
        if(length(which(values2$df$substrates >=0)) < 10 && length(which(values2$df$substrates >=0)) > 0){
            values2$df[1: length(which(values2$df$substrates >=0)), c("times", "substrates", "slopes")]
        }
        else if (length(which(values2$df$substrates >=0)) >= 10){
            values2$df[1:10, c("times", "substrates", "slopes")]
        }
        else{
            values2$df[1, c("times", "substrates", "slopes")]
        }
    }, striped = TRUE, bordered = TRUE, align = "c", width = 300)
}
