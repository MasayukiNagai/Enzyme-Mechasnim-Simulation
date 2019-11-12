library(shiny)
library(VGAM)
library(stats4)
library(splines)

source("plot_Pt.R")
source("plot_MM.R")
source("lambertPt.R")
source("simpleplot_Pt.R")


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
#the max time of exercise 1
time_max = 500

enzymes1 = c(0.1, 0.01, 0.001, 0.0001)
#why sd = sd/5??
file_1 = lambertPt(s = s1, e = enzymes1[1], time = time_max, k2 = k2, km = km, s_max = s1, pinf_ratio = pinf_ratio, interval = interval, sd = sd/5)
file_2 = lambertPt(s = s1, e = enzymes1[2], time = time_max, k2 = k2, km = km, s_max = s1, pinf_ratio = pinf_ratio, interval = interval, sd = sd/5)
file_3 = lambertPt(s = s1, e = enzymes1[3], time = time_max, k2 = k2, km = km, s_max = s1, pinf_ratio = pinf_ratio, interval = interval, sd = sd/5)
file_4 = lambertPt(s = s1, e = enzymes1[4], time = time_max, k2 = k2, km = km, s_max = s1, pinf_ratio = pinf_ratio, interval = interval, sd = sd/5)
df_pt_error = data.frame("pt_error_1" = file_1$pt_error, "pt_error_2" = file_2$pt_error, "pt_error_3" = file_3$pt_error, "pt_error_4" = file_4$pt_error)


server = function(input, output, session) {

#About
    output$about = renderUI({
        includeHTML("Captions/about.html")
    })
    
# Exercise 1
    
    output$substrate1 = renderText({
        paste("Substrate Concentration is: ", "<b>", "x μM", "<b>")
    })
    
    output$graph_Pt1 = renderPlot({
        simpleplot_Pt(enzymes = enzymes1,
                      df_pt = df_pt_error,
                      time_max = time_max,
                      time = input$time1,
                      interval = interval,
                      s_max = s1,
                      a_plot = 0.1 %in% input$e1,
                      b_plot = 0.01 %in% input$e1,
                      c_plot = 0.001 %in% input$e1,
                      d_plot = 0.0001 %in% input$e1)
    })
    
    
# Exercise 2
    output$enzyme2 = renderText({
        paste("Enzyme concentration from Ex1:", "<b>", input$e, " μM", "</b>")
    })
    
    # output$instruction_2 = renderUI({
    #     includeHTML("Captions/instruction_ex2.html")
    # })
    
    
    length2 = as.numeric(formatC((time_max/interval + 1), format = "d"))
    
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
            file = lambertPt(s = input$s2, e = as.numeric(input$e), time = time_max, k2 = k2, km = km, s_max = s_max, pinf_ratio = pinf_ratio, interval = interval, sd = sd/10)
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
                time_max = time_max,
                time = input$time,
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
            file = lambertPt(s = input$s3, e = as.numeric(input$e), time = time_max, k2 = k2, km = km, s_max = s_max, pinf_ratio = pinf_ratio, interval = interval, sd = sd)
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
    
    #reset every data when the enzyme concentration was changed
    reset = observeEvent(input$e, {
        count = length(values2$df$substrates[!is.na(values2$df$substrates)])
        values2$df[1:count, ] = NA
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
    
    observe({
        e = as.numeric(input$e)
        vmax = k2 * e
        updateSliderInput(session, "vmax4", 
                          value = 0.6 * k2 * e, max = 2.0 * vmax, step = vmax/100)
        updateSliderInput(session, "km4",
                          value = 2)
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
