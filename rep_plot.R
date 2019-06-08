rep_plot = function(file,
                    e_individuals = TRUE, s_individuals = TRUE, es_individuals = TRUE, p_individuals = TRUE,
                    e_average_display = TRUE, s_average_display = TRUE, es_average_display = TRUE, p_average_display = TRUE){
  
  ymax = 1.1 * max(file$e_average, file$s_average, file$es_average, file$p_average)
  plot(x = -100, y = -100, type = "p", lwd = 1, lty = 1,
       xlim = c(0, max(file$time)), ylim = c(0, ymax), xlab = "", ylab = "")
  mtext("Time", side = 1, line = 2, cex = 1.5)
  mtext("Counts", side = 2, line = 2, cex = 1.5)
  mtext("Enzyme Mechanism: E + S" ~ symbol("\253") ~ "ES" ~ symbol("\256") ~ "E + P", 
        side = 3, line = 1.5, cex = 2.5)
  
  if(e_individuals){
    matlines(x = file$time, y = file$e_reps, lty = 1, lwd = 1, col = "cyan")
  }
  if(s_individuals){
    matlines(x = file$time, y = file$s_reps, lty = 1, lwd = 1, col = "green")
  }
  if(es_individuals){
    matlines(x = file$time, y = file$es_reps, lty = 1, lwd = 1, col = "violet")
  }
  if(p_individuals){
    matlines(x = file$time, y = file$p_reps, lty = 1, lwd = 1, col = "pink")
  }
  if(e_average_display){
    lines(x = file$time, y = file$e_average, lty = 2, lwd = 2, col = "blue")
  }
  if(s_average_display){
    lines(x = file$time, y = file$s_average, lty = 2, lwd = 2, col = "darkgreen")
  }
  if(es_average_display){
    lines(x = file$time, y = file$es_average, lty = 2, lwd = 2, col = "purple4")
  }
  if(p_average_display){
    lines(x = file$time, y = file$p_average, lty = 2, lwd = 2, col = "magenta")
  }
  
  legend_text = c("E","S","ES","P","averages")
  legend_pch = c(15, 15, 15, 15, NA)
  legend_color = c("cyan", "green", "violet", "pink")
  legend_lty = c(NA, NA, NA, NA, 2)
  legend_lwd = c(NA, NA, NA, NA, 2)
  
  legend(x = "top", horiz = TRUE,
         legend = legend_text, pch = legend_pch, pt.cex = 1.5,
         col = legend_color, lty = legend_lty, lwd = legend_lwd, bty = "n")
  grid(col = "black")
}

