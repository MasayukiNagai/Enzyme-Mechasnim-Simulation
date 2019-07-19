source("change_color.R")
plot_MM = function(file, e = 1, i = 1,
                   k1 = 1000, k_1 = 950, k2 = 50, km = NULL, ki1 = 0.20, ki2 = 0.15,
                   s_max = 10, pinf_ratio = 0.9818,
                   km_pre= 2, vmax_pre = 1000 * 10^(-6),
                   game = c("Normal", "Competitive", "Uncompetitive", "Mixed"),
                   display_theoretical_values = FALSE, display_calculated_values = FALSE, display_fit_values = FALSE){
  
  #set km and vmax
  if(is.null(km)){
    km = (k_1 + k2)/ k1
  }
  v_max = k2 * e
  
  game = match.arg(game)
  #set kmapp and vmapp based on the enzyme kinetics
  if(game == "Competitive"){
    kmapp = km * (1 + i/ki1)
    vapp = v_max * 1
  }
  else if(game == "Uncompetitive"){
    kmapp = km/(1 + i/ki2)
    vapp = v_max/(1 + i/ki2)
  }
  else if(game == "Mixed"){
    kmapp = km * (1 + i/ki1) / (1 + i/ki2)
    vapp = v_max/(1 + i/ki2) 
  }
  else{
    kmapp = km
    vapp = v_max
  }
  
  count = length(file$substrates[!is.na(file$substrates)])
  ymax = 1.1 * vapp
  
  #check if the first trial is done or not
  if(count == 0){
    #only plot a graph without any lines
    plot(x = -100, y = -100, type = "p", lwd = 1, lty = 1,
         xlim = c(0, s_max), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("substrate concentration, [S] (μM)", side = 1, line = 3, cex = 1.5)
    mtext("initial rate, V0 (μM/s)", side = 2, line = 3, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
  }
  else{
    plot(x = -100, y = -100, type = "p", lwd = 1, lty = 1,
         xlim = c(0, s_max), ylim = c(0, ymax), xlab = "", ylab = "")
    mtext("substrate concentration, [S] (μM)", side = 1, line = 3, cex = 1.5)
    mtext("initial rate, V0 (μM/s)", side = 2, line = 3, cex = 1.5)
    # mtext(main_title, side = 3, line = 1.5, cex = 2.5)
    grid(col = "black")
    color = unlist(lapply(as.numeric(file$slopes[1:count])/vapp, change_color))
    lines(x = file$substrates[1:count], y = file$slopes[1:count], type = "p", pch = 19, col = color, cex = 2)
    if(display_theoretical_values){
      #display theoretical curves which programms use to generate values
      curve(vapp * x/(kmapp + x), 0, s_max, add = TRUE, type = "l", lwd = 3, lty = 2, col = "red")
      lines(x = kmapp, y = vapp/2, type = "p", pch = 5, col = "red", cex = 2.5, lwd = 2)
      abline(h = vapp, lwd = 3, lty = 2, col = "red")
    }
    if(display_calculated_values){
      y = as.numeric(file$slopes[1:count])
      s = as.numeric(file$substrates[1:count])
      #non linear regression from plots which users generated
      m = nls(y ~ a * s/(b + s), start = list(a = vapp, b = kmapp))
      vmc = coef(m)[1]
      kmc = coef(m)[2]
      curve(vmc * x/(kmc + x), 0, s_max, add = TRUE, type = "l", lwd = 3, lty = 2, col = "darkgreen")
      lines(x = kmc, y = vmc/2, type = "p", pch = 5, col = "darkgreen", cex = 2.5, lwd = 2)
    }
    if(display_fit_values){
      #display MM curve using values which users choose
      curve(vmax_pre * x/(km_pre + x), 0, s_max, add = TRUE, type = "l", lwd = 2, lty = 2, col = "blueviolet")
      lines(x = km_pre, y = vmax_pre/2, type = "p", pch = 5, col = "blueviolet", cex = 2.3, lwd = 2)
    }
  }
}