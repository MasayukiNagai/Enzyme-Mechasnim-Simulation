plot_lambert = function(file){
  
  #adjust smax depending on the max of substrate value that users can choose (check ui)
  s_max = 10
  pinf = file$pinf_ratio * s_max
  pt_max = pinf - file$kmapp * lambertW({(pinf/file$kmapp) * exp((pinf - file$vapp * file$time)/file$kmapp)})
  ymax = pt_max
  plot(x = -100, y = -100, type = "p",
       xlim = c(0, file$time), ylim = c(0, ymax), xlab = "Time (s)", ylab = "[P] (M)")
  # mtext("Time (s)", side = 1, line = 2, cex = 1.5)
  # mtext("[P] (M)", side = 2, line = 2, cex = 1.5)
  # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
  
  matlines(x = file$t, y = file$pt, type = "l", lty = 1, lwd = 2, col = "darkgreen")
  matlines(x = file$t, y = file$pt_error, type = "p", pch = 1, col = "black")
  
  xval = matrix(data = c(0, file$time), ncol = 1)
  yval1 = file$intercepts_error + file$slopes_error * 0
  yval2 = file$intercepts_error + file$slopes_error * file$time
  yvalues = rbind(yval1, yval2)
  
  matlines(x = xval, y = yvalues, type = "l", lty = 2, lwd = 1, col = "blue")
}