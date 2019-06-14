plotMM = function(file){
  
  ymax = 1.1 * max(file$v_init)
  plot(x = -100, y = -100, type = "p", 
       xlim = c(0, file$s_axis), ylim = c(0, ymax), xlab = "", ylab = "")
  mtext("[S]: Concentration of Substrates", side = 1, line = 2.5, cex = 1.5)
  mtext("V0: Initial Rate of Formation of Product", side = 2, line = 2.5, cex = 1.5)
  mtext("Michaelis-Menten Equation", side = 3, line = 2, cex = 2.5)
  
  matlines(x = file$s, y = file$v_init, lty = 1, lwd = 4, col = "darkgreen")
  
  grid(col = "black")
  
}