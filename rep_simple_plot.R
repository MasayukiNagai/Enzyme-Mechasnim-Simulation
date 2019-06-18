rep_simple_plot = function(file){
  #change ymax after making it possible to plot multiple graphs
  ymax = 1*1
  plot(x = -100, y = -100, type = "p", lwd = 1, lty = 1,
       xlim = c(0, max(file$time)), ylim = c(0, ymax), xlab = "", ylab = "")
  mtext("Time", side = 1, line = 2, cex = 1.5)
  mtext("P Counts", side = 2, line = 2, cex = 1.5)
  mtext("Enzyme Mechanism: E + S" ~ symbol("\253") ~ "ES" ~ symbol("\256") ~ "E + P", 
        side = 3, line = 1.5, cex = 2.5)
  
  lines(x = file$time, y = file$p_average, lwd = 3, col = "blue")
  
  abline(file$coeff, file$slope)
  
  grid(col = "black")
}