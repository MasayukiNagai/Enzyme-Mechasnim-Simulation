simple_plot = function(file, 
                       e_plot = TRUE, s_plot = TRUE, es_plot = TRUE, p_plot = TRUE){
  
  # create vector of which marble counts to plot
  marbles_to_plot = c(e_plot, s_plot, es_plot, p_plot)
  
  # create vectors for legend text and line colors
  legend_text = c("E", "S", "ES", "P")
  line_color = c("blue", "green", "purple", "magenta")
  
  #create a plot
  marble_count = data.frame(file$e_count, file$s_count, file$es_count, file$p_count)
  matplot(x = file$time,
          y = marble_count[, which(marbles_to_plot == TRUE)],
          col = line_color[which(marbles_to_plot == TRUE)],
          type = "l", lwd = 2, lty = 1,
          ylim = c(0, 1.1 * max(marble_count)),
          xlim = c(0, max(file$time)),
          xlab = "time",
          ylab = "count",
          main = "Enzyme Mechanism: E + S" ~ symbol("\253") ~ "ES" ~ symbol("\256") ~ "E + P")
  legend(x = "top", horiz = TRUE,
         legend = legend_text[which(marbles_to_plot == TRUE)],
         col = line_color[which(marbles_to_plot == TRUE)],
         lwd = 2, lty = 1, bty = 1)
  grid(col = "black")
}