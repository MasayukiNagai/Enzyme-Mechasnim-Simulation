source("change_color.R")
plot_lambert = function(file,
                        display_theoretical_values = FALSE){
  
  s_max = file$s_max
  
  pinf = file$pinf_ratio * s_max
  pt_max = pinf - file$kmapp * lambertW({(pinf/file$kmapp) * exp((pinf - file$vapp * file$time)/file$kmapp)})
  ymax = 1.1 * pt_max
  if(length(file$pt) == 0){
    plot(x = -100, y = -100, type = "p",
         xlim = c(0, file$time), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("Time (s)", side = 1, line = 2, cex = 1.5)
    mtext("[P] (M)", side = 2, line = 2, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
  }
  else{
    plot(x = -100, y = -100, type = "p",
         xlim = c(0, file$time), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("Time (s)", side = 1, line = 2, cex = 1.5)
    mtext("[P] (M)", side = 2, line = 2, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
    if(display_theoretical_values){
      matlines(x = file$t, y = file$pt, type = "l", lty = 1, lwd = 2, col = "red")
    }
    matlines(x = file$t, y = file$pt_error, type = "p", pch = 1, col = "black")
    
    xval = matrix(data = c(0, file$time), ncol = 1)
    yval1 = file$intercepts_error + file$slopes_error * 0
    yval2 = file$intercepts_error + file$slopes_error * file$time
    yvalues = rbind(yval1, yval2)
    color = unlist(lapply(file$slopes_error/file$vapp, change_color))
    matlines(x = xval, y = yvalues, type = "l", lty = 2, lwd = 2, col = color)
  }
}