library(shiny)
library(VGAM)
library(stats4)
library(splines)

source("plot_Pt.R")
source("plot_MM.R")
source("lambertPt.R")
source("simple_plot_Pt.R")

#change the values of variables 
km = 1
k2 = 50
#the max formation rate of product
pinf_ratio = 0.9818
#degree of deviation
sd = 0.01
#the maximum value of substrates (slider)
s_max = 10
#the number of points you get for each data
interval = 0.1
#substrate concentration for exercise 1 (μM) (from 1 to 10)
s1 = 1

server = function(input, output, session) {

#About
    output$about = renderUI({
        includeHTML("Captions/about.html")
    })
    
#Overview
    #create vectors/matrices to compose a data frame which stores data entered by users
    substrates0 = rep(NA, 20)
    pt0 = matrix(nrow = 20, ncol = interval)
    pt_error0 = matrix(nrow = 20, ncol = interval)
    slopes0 = rep(NA, 20)
    intercepts0 = rep(NA, 20)
    values0 = reactiveValues(df = data.frame("substrates" = substrates0, "slopes" = slopes0, "intercepts" = intercepts0, "pt_error" = pt_error0, "pt" = pt0))
    #when users put add button, this checks if the value is already in the data frame or not and if not it adds the value and other related valeus calculated using the concentration
    newEntry0 = observeEvent(input$add_s0, {
        count = length(values0$df$substrates[!is.na(values0$df$substrates)])
        if(!(input$s0 %in% values0$df$substrates) && count < 10){
            length0 = as.numeric(formatC((input$time0/interval + 1), format = "d"))
            file = lambertPt(s = input$s0, e = as.numeric(input$e0), time = input$time0, k2 = k2, km = km, s_max = s_max,  pinf_ratio = pinf_ratio, interval = interval, sd = sd)
            values0$df$substrates[(count + 1)] = input$s0
            values0$df[(count + 1), (4 + length0) : (3 + length0 + length0)]= file$pt
            values0$df[(count + 1), 4 : (3 + length0)] = file$pt_error
            values0$df$slopes[(count + 1)] = formatC(file$slopes_error, format = "e", digits = 3)
            values0$df$intercepts[(count + 1)] = file$intercepts_error
        } 
    })
    
    #reset an existing data frame by pushing a button
    reset0 = observeEvent(input$reset0, {
        count = length(values0$df$substrates[!is.na(values0$df$substrates)])
        values0$df[1:count, ] = NA
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
    
    #plot Pt graph
    output$graph_Pt0 = renderPlot({
        plot_Pt(file = values0$df,
                e = as.numeric(input$e0),
                time = input$time0,
                s_max = s_max,
                interval = interval,
                pinf_ratio = pinf_ratio,
                km = km,
                display_theoretical_values = input$theory0)
    })
    
    #plot MM graph
    output$graph_MM0 = renderPlot({
        plot_MM(file = values0$df,
                e = as.numeric(input$e0),
                s_max = s_max,
                pinf_ratio = pinf_ratio,
                km = km,
                km_pre = input$km0,
                vmax_pre = input$vmax0,
                display_theoretical_values = input$theory0,
                display_fit_values = input$fit0)
    })
    
    #calculate error (this uses Km not Kapp so if you appy inhibitor values, this needs to be fixed as well)
    output$error0 = renderText({
        vmax0 = k2 * as.numeric(input$e0)
        count = length(values0$df$substrates[!is.na(values0$df$substrates)])
        theo = vmax0 * as.numeric(values0$df$substrates[1:count])/(km + as.numeric(values0$df$substrates[1:count]))
        exp = input$vmax0 * as.numeric(values0$df$substrates[1:count])/(input$km0 + as.numeric(values0$df$substrates[1:count]))
        error = round(sum(sqrt((theo - exp)^2))/as.numeric(input$e0), 2)
        paste("<b>Error: ", error, "</b>")
    })
    
    #display theoretical values
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
    output$substrate1 = renderText({
        paste("Substrate Concentration is: ", "<b>", "x μM", "<b>")
    })

    #calculate one sequence of pt 
    calcPt = reactive({
        out = lambertPt(s = s1,
                        e = as.numeric(input$e1) * s1,
                        k2 = k2,
                        km = km,
                        s_max = s1,
                        pinf_ratio = pinf_ratio,
                        time = input$time1,
                        interval = input$interval1,
                        sd = sd,
                        timechecker = FALSE)
        out
    })

    #plot only one Pt graph
    output$graph_Pt1 = renderPlot({
        simple_plot_Pt(file = calcPt())
    })
    
    
# Exercise 2
    output$enzyme2 = renderText({
        paste("Enzyme concentration from Ex1:", "<b>", input$e, " μM", "</b>")
    })
    
    # output$instruction_2 = renderUI({
    #     includeHTML("Captions/instruction_ex2.html")
    # })
    
    #time should be determined by ex1
    time2 = 15
    length2 = as.numeric(formatC((time2/interval + 1), format = "d"))
    
    #create vectors/matrices to compose a data frame which stores data entered by users
    times2 = rep(NA, 20)
    substrates2 = rep(NA, 20)
    pt2 = matrix(nrow = 20, ncol = length2)
    pt_error2 = matrix(nrow = 20, ncol = length2)
    slopes2 = rep(NA, 20)
    intercepts2 = rep(NA, 20)
    values2 = reactiveValues(df = data.frame("substrates" = substrates2, "slopes" = slopes2, "intercepts" = intercepts2, "pt_error" = pt_error2, "pt" = pt2, "times" = times2))
    #when users push the add button, this checks if the value is already in the data frame or not and if not it adds the value and other related valeus calculated using the concentration
    #data frame can store up to 5 data
    newEntry2 = observeEvent(input$add_s2, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        if(!(input$s2 %in% values2$df$substrates) && count < 5){
            file = lambertPt(s = input$s2, e = as.numeric(input$e), time = time2, k2 = k2, km = km, s_max = s_max, pinf_ratio = pinf_ratio, interval = interval, sd = sd)
            values2$df$substrates[(count + 1)] = input$s2
            values2$df[(count + 1), (4 + length2) : (3 + length2 + length2)]= file$pt
            values2$df[(count + 1), 4 : (3 + length2)] = file$pt_error
            values2$df$slopes[(count + 1)] = formatC(file$slopes_error, format = "e", digits = 3)
            values2$df$intercepts[(count + 1)] = file$intercepts_error
            values2$df$times[(count + 1)] = formatC(count + 1, format = "d")
        } 
    })
    
    #reset an existing data frame when the reset button is pushed
    reset2 = observeEvent(input$reset2, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        values2$df[1:count, ] = NA
    })

    #plot a Pt graph
    output$graph_Pt2 = renderPlot({
        plot_Pt(file = values2$df,
                e = as.numeric(input$e),
                km = km,
                time = time2,
                interval = interval,
                s_max = s_max,
                pinf_ratio = pinf_ratio)
    })
    
    #create a table from data frame
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
        paste("Enzyme concentration from Ex1:", "<b>", input$e, " μM", "</b>")
    })
    
    # output$instruction_3 = renderUI({
    #     includeHTML("Captions/instruction_ex3.html")
    # })
    
    #when users push the add button, this checks if the value is already in the data frame or not and if not it adds the value and other related valeus calculated using the concentration
    #data frame can store up to 10 data
    newEntry3 = observeEvent(input$add_s3, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        if(!(input$s3 %in% values2$df$substrates) && count < 10){
            file = lambertPt(s = input$s3, e = as.numeric(input$e), time = time2, k2 = k2, km = km, s_max = s_max, pinf_ratio = pinf_ratio, interval = interval, sd = sd)
            values2$df$substrates[(count + 1)] = input$s3
            values2$df[(count + 1), (4 + length2) : (3 + length2 + length2)]= file$pt
            values2$df[(count + 1), 4 : (3 + length2)] = file$pt_error
            values2$df$slopes[(count + 1)] = formatC(file$slopes_error, format = "e", digits = 3)
            values2$df$intercepts[(count + 1)] = file$intercepts_error
            values2$df$times[(count + 1)] = formatC(count + 1, format = "d")
        } 
    })
    
    #reset an existing data in the data franme which is created by the exercise3 when the reset button is pushed
    reset3 = observeEvent(input$reset3, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        if(count > 5){
            values2$df[6:count, ] = NA
        }
    })
    
    #plot MM graph
    output$graph_MM3 = renderPlot({
        plot_MM(file = values2$df,
                e = as.numeric(input$e),
                km = km,
                s_max = s_max,
                pinf_ratio = pinf_ratio)
    })
    
    #create a table 
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
        paste("Enzyme concentration from Ex1:", "<b>", input$e, " μM", "</b>")
    })
    
    #calculate error of users' prediction from plots and display the value
    output$error4 = renderText({
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        theo = as.numeric(input$vmax4) * as.numeric(values2$df$substrates[1:count])/(as.numeric(input$km4) + as.numeric(values2$df$substrates[1:count]))
        exp = as.numeric(values2$df$slopes[1:count])
        error = round(sum(sqrt((theo - exp)^2))/as.numeric(input$e), 2)
        paste("<b>Error from plots: ", error, "</b>")
    })
    
    # output$instruction_4 = renderUI({
    #     includeHTML("Captions/instruction_ex4.html")
    # })
    
    #plot MM graph with users' prediction, calculated values, and theoretical values
    output$graph_MM4 = renderPlot({
        plot_MM(file = values2$df,
                e = as.numeric(input$e),
                km = km,
                s_max = s_max,
                pinf_ratio = pinf_ratio,
                km_pre = input$km4,
                vmax_pre = input$vmax4,
                display_theoretical_values = input$theory4,
                display_calculated_values = input$calculated4,
                display_fit_values = TRUE)
    })
    
    #create a table
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
