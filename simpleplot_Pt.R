simpleplot_Pt = function(enzymes, df_pt, e = 1, time_max = 500, time = 500, interval = 0.1, s_max = 10,
                         a_plot = TRUE, b_plot = TRUE, c_plot = TRUE, d_plot = TRUE){
  
  lines_to_plot = c(a_plot, b_plot, c_plot, d_plot)
  length = as.numeric(formatC((time/interval + 1), format = "d"))
  t = seq(0, time_max, by = interval)
  plot(x = -100, y = -100, type = "p",
       xlim = c(0, time), ylim = c(0, s_max), xlab = "", ylab = "")
  mtext("time (s)", side = 1, line = 3, cex = 1.5)
  mtext("ratio of product concentration,[P]", side = 2, line = 3, cex = 1.5)
  # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
  grid(col = "black")
  if(length(which(lines_to_plot == TRUE)) > 0){
    matlines(x = t, y = df_pt[, which(lines_to_plot == TRUE)], 
             xlim = c(0, time), ylim = c(0, 1.1 * s_max),
             type = "l", lty = 1, lwd = 2, col = "black")
  }

}