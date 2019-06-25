plot_lambertMM = function(file, display_theoretical_values = FALSE){
  
  if(length(file$pt) == 0){
    s_max = 1
  }
  else{
    s_max = 1.2 * max(file$substrates)
  }
  ymax = 1.1 * file$vapp
  if(length(file$pt) == 0){
    plot(x = -100, y = -100, type = "p", lwd = 1, lty = 1,
         xlim = c(0, s_max), ylim = c(0, ymax), xlab = "[S] (M)", ylab = "Initial Velocity, V0 (M/s)")
    # mtext("[S] (μM)", side = 1, line = 2, cex = 1.5)
    # mtext("Initial Velocity, V0 (μM/s)", side = 2, line = 2, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
  }
  else{
    plot(x = -100, y = -100, type = "p", lwd = 1, lty = 1,
         xlim = c(0, s_max), ylim = c(0, ymax), xlab = "[S] (M)", ylab = "Initial Velocity, V0 (M/s)")
    # mtext("[S] (μM)", side = 1, line = 2, cex = 1.5)
    # mtext("Initial Velocity, V0 (μM/s)", side = 2, line = 2, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
    color = unlist(lapply(file$slopes_error/file$vapp, change_color))
    lines(x = file$substrates, y = file$slopes_error, type = "p", pch = 19, col = color, cex = 2)
    v_max = file$vapp
    km = file$kmapp
    if(display_theoretical_values){
      curve(v_max * x/(km + x), 0, s_max, add = TRUE, type = "l", lwd = 2, lty = 2, col = "red")
    }
  }
}