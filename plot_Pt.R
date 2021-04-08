source("change_color.R")
plot_Pt = function(file, e = 1, i = 1,
                   k1 = 1000, k_1 = 950, k2 = 50, km = NULL, ki1 = 0.20, ki2 = 0.15,
                   time_max = 500, time = 150, s_max = 10, interval = 1, pinf_ratio = 0.9818,
                   mechanism = c("Normal", "Competitive", "Uncompetitive", "Mixed"),
                   display_slopes = TRUE, display_theoretical_values = FALSE){

  #set km and vmax
  if(is.null(km)){
    km = (k_1 + k2)/ k1
  }
  v_max = k2 * e
  
  mechanism = match.arg(mechanism)
  #set kmapp and vmapp based on the enzyme kinetics
  if(mechanism == "Competitive"){
    kmapp = km * (1 + i/ki1)
    vapp = v_max * 1
  }
  else if(mechanism == "Uncompetitive"){
    kmapp = km/(1 + i/ki2)
    vapp = v_max/(1 + i/ki2)
  }
  else if(mechanism == "Mixed"){
    kmapp = km * (1 + i/ki1) / (1 + i/ki2)
    vapp = v_max/(1 + i/ki2) 
  }
  else{
    kmapp = km
    vapp = v_max
  }
  

  count = length(file$substrates[!is.na(file$substrates)])
  length = as.numeric(formatC((time_max/interval + 1), format = "d"))
  t = seq(0, time_max, by = interval)
  #the max concentration of product
  pinf = pinf_ratio * s_max
  #the max concentration of product within time which users choose
  pt_max = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * time)/kmapp)})
  ymax = 1.1 * pt_max
  
  #checking if the first trial is done or not
  if(count == 0){
    #only plot a graph without any lines
    plot(x = -100, y = -100, type = "p",
         xlim = c(0, time), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("time (s)", side = 1, line = 3, cex = 1.5)
    mtext("product concentration, [P] (μM)", side = 2, line = 3, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
  }
  else{
    plot(x = -100, y = -100, type = "p",
         xlim = c(0, time), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("time (s)", side = 1, line = 3, cex = 1.5)
    mtext("product concentration, [P] (μM)", side = 2, line = 3, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
    if(display_theoretical_values){
      matlines(x = t, y = t(file[1 : count, (3 + length) : (4 + length + length)]), type = "l", lty = 2, lwd = 2, col = "red")
    }
    matlines(x = t, y = t(file[1 : count, 4 : (3 + length)]), type = "l", lty = 1, lwd = 2, col = "black")
    
    if(display_slopes){
      #display multiple slopes
      xval = matrix(data = c(0, time_max), ncol = 1)
      yval1 = as.numeric(file$intercepts[1:count]) + as.numeric(file$slopes[1:count]) * 0
      yval2 = as.numeric(file$intercepts[1:count]) + as.numeric(file$slopes[1:count]) * time_max
      yvalues = rbind(yval1, yval2)
      color = unlist(lapply(as.numeric(file$slopes[1:count])/vapp, change_color))
      matlines(x = xval, y = yvalues, type = "l", lty = 2, lwd = 3, col = color)
    }
  }

}