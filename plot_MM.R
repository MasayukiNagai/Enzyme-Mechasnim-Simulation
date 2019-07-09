plot_MM = function(file, time = 1000, interval = 50, 
                   s_max = 10, pinf_ratio = 0.9818, kmapp = 1, vapp = 500 * 10^(-6),
                   km_pre= 2, vmax_pre = 1000 * 10^(-6),
                   display_theoretical_values = FALSE,display_fit_values = FALSE){
  
  ymax = 1.1 * file$vapp
  if(is.na[1,4]){
    plot(x = -100, y = -100, type = "p", lwd = 1, lty = 1,
         xlim = c(0, s_max), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("[S] (M)", side = 1, line = 2, cex = 1.5)
    mtext("Initial Velocity, V0 (M/s)", side = 2, line = 2, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
  }
  else{
    plot(x = -100, y = -100, type = "p", lwd = 1, lty = 1,
         xlim = c(0, s_max), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("[S] (M)", side = 1, line = 2, cex = 1.5)
    mtext("Initial Velocity, V0 (M/s)", side = 2, line = 2, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
    color = unlist(lapply(file$slopes/vapp, change_color))
    lines(x = file$substrates, y = file$slopes, type = "p", pch = 19, col = color, cex = 2)
    v_max = vapp
    km = kmapp
    if(display_theoretical_values){
      curve(v_max * x/(km + x), 0, s_max, add = TRUE, type = "l", lwd = 2, lty = 2, col = "red")
      abline(h = file$vapp, lwd = 2, lty = 2, col = "red")
    }
    if(display_fit_values){
      curve(vmax_pre * x/(km_pre + x), 0, s_max, add = TRUE, type = "l", lwd = 2, lty = 2, col = "blue")
    }
  }
}