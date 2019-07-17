source("change_color.R")
plot_Pt = function(file,
                   time = 1000, s_max = 10, time_max = 10000, pinf_ratio = 0.9818, kmapp = 1, vapp = 5000 * 10^(-6),
                   display_theoretical_values = FALSE){
  
  count = length(file$substrates[!is.na(file$substrates)])
  t = seq(0, time)
  pinf = pinf_ratio * s_max
  pt_max = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * time)/kmapp)})
  ymax = 1.1 * s_max
  #checking if the first trial is done or not by seeing the first cell of pt
  if(count == 0){
    plot(x = -100, y = -100, type = "p",
         xlim = c(0, time), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("time (s)", side = 1, line = 3, cex = 1.5)
    mtext("product concentration, [P] (M)", side = 2, line = 3, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
  }
  else{
    plot(x = -100, y = -100, type = "p",
         xlim = c(0, time), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("time (s)", side = 1, line = 3, cex = 1.5)
    mtext("product concentration, [P] (M)", side = 2, line = 3, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
    if(display_theoretical_values){
      matlines(x = t, y = t(file[1 : count, (5 + time_max) : (5 + time + time_max)]), type = "l", lty = 2, lwd = 2, col = "red")
    }
    matlines(x = t, y = t(file[1 : count, 4 : (4 + time)]), type = "l", lty = 1, lwd = 2, col = "black")
    
    xval = matrix(data = c(0, time), ncol = 1)
    yval1 = as.numeric(file$intercepts[1:count]) + as.numeric(file$slopes[1:count]) * 0
    yval2 = as.numeric(file$intercepts[1:count]) + as.numeric(file$slopes[1:count]) * time
    yvalues = rbind(yval1, yval2)
    color = unlist(lapply(as.numeric(file$slopes[1:count])/vapp, change_color))
    matlines(x = xval, y = yvalues, type = "l", lty = 2, lwd = 3, col = color)
  }
}