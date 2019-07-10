source("change_color.R")
simple_plot_Pt = function(file,
                          display_theoretical_values = FALSE){
  
  t = seq(0, file$time)
  pinf = pinf_ratio * file$s_max
  pt_max = pinf - file$kmapp * lambertW({(pinf/file$kmapp) * exp((pinf - file$vapp * file$time)/file$kmapp)})
  ymax = 1.1 * file$s_max
  plot(x = -100, y = -100, type = "p",
       xlim = c(0, time), ylim = c(0, ymax), xlab = "", ylab = "")
  mtext("time (s)", side = 1, line = 3, cex = 1.5)
  mtext("product concentration, [P] (M)", side = 2, line = 3, cex = 1.5)
  # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
  grid(col = "black")
  if(display_theoretical_values){
    matlines(x = t, y = file$pt[0 : length(t)], type = "l", lty = 2, lwd = 2, col = "red")
  }
  matlines(x = t, y = file$pt_error[0 : length(t)], type = "l", lty = 1, lwd = 2, col = "black")
  abline(a = file$intercept_error, b = file$slopes_error, col = "blue")
}