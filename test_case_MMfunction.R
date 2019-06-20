#test case2

setwd("~/DePauw/Summer2019/Enzyme")
library(stats4)
library(splines)
library(VGAM)
source("lambertMM.R")
# nano order
# e0 = 20 * 10^(-9)
# s0 = 40000 * 10^(-9)
# 
# k1 = 1.3 * 10^9
# k_1 = 1.0 * 10^5
# k2 = 1.4 * 10^(-4)
# km = 9 * 10^(-5) 
# tau = 1/(k_1 + k2 + k1 * s0)
# t = seq(1:100000)
# p = e0 * k1 * k2 * s0 * tau * (t + 1/tau * (exp(-t/tau) - 1))
# plot(x = t, y = p, type = "l", lwd = 3, col = "red")


lambertMM3 = function(s = 150, solvent = 150, 
                     pinf = 0.9818, vapp = 17.4, kmapp = 231, time = 100){
  t = seq(0, time, 1)
  pinf = pinf * s
  pt = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * t)/kmapp)})
  slope = vapp * pinf /(kmapp + pinf)
  y_intercept = 0
  
  out = list("pt" = pt,
             "t" = t,
             "time" = time,
             "pinf" = pinf,
             "vapp" = vapp,
             "kmapp" = kmapp,
             "s" = s,
             "solvent" = solvent,
             "slope" = slope,
             "y_intercept" = y_intercept)
}



# exp1 = lambertMM3(s = 1000, solvent = 0)
# exp2 = lambertMM3(s = 900, solvent = 0)
# exp3 = lambertMM3(s = 800, solvent = 0)
# exp4 = lambertMM3(s = 50, solvent = 0)
# exp5 = lambertMM3(s = 300, solvent = 0)
# exp6 = lambertMM3(s = 100, solvent = 0)
# t = exp1$t
# plot(x = t, y = exp1$pt, type = "l", lwd = 3, col = "blue")
# lines(x = t, y = exp2$pt, type = "l", lwd = 3, col = "blue")
# lines(x = t, y = exp3$pt, type = "l", lwd = 3, col = "blue")
# lines(x = t, y = exp4$pt, type = "l", lwd = 3, col = "blue")
# lines(x = t, y = exp5$pt, type = "l", lwd = 3, col = "blue")
# lines(x = t, y = exp6$pt, type = "l", lwd = 3, col = "blue")
# abline(exp1$y_intercept, exp1$slope, col = "cyan")
# abline(exp2$y_intercept, exp2$slope, col = "cyan")
# abline(exp3$y_intercept, exp3$slope, col = "cyan")
# abline(exp4$y_intercept, exp4$slope, col = "cyan")
# abline(exp5$y_intercept, exp5$slope, col = "cyan")
# abline(exp6$y_intercept, exp6$slope, col = "cyan")
# slopes = c(exp1$slope,exp2$slope,exp3$slope,exp4$slope,exp5$slope,exp6$slope)
# substrates = c(exp1$s, exp2$s,exp3$s,exp4$s,exp5$s,exp6$s)
# solvents = c(exp1$solvent, exp2$solvent,exp3$solvent,exp4$solvent,exp5$solvent,exp6$solvent)
# cons = substrates/(substrates + solvents)
# 
# plot(x = substrates, y = slopes)


exp1 = lambertMM(s = 5, e = 0.02)
exp2 = lambertMM(s = 4, e = 0.02)
exp3 = lambertMM(s = 3, e = 0.02)
exp4 = lambertMM(s = 2, e = 0.02)
exp5 = lambertMM(s = 1, e = 0.02)
exp6 = lambertMM(s = 0, e = 0.02)
t = exp1$t
plot(x = t, y = exp1$pt, type = "l", lwd = 2, col = "blue")
lines(x = t, y = exp2$pt, type = "l", lwd = 2, col = "blue")
lines(x = t, y = exp3$pt, type = "l", lwd = 2, col = "blue")
lines(x = t, y = exp4$pt, type = "l", lwd = 2, col = "blue")
lines(x = t, y = exp5$pt, type = "l", lwd = 2, col = "blue")
lines(x = t, y = exp6$pt, type = "l", lwd = 2, col = "blue")
lines(x = t, y = exp1$pt_error, type = "p")
lines(x = t, y = exp2$pt_error, type = "p")
lines(x = t, y = exp3$pt_error, type = "p")
lines(x = t, y = exp4$pt_error, type = "p")
lines(x = t, y = exp5$pt_error, type = "p")
lines(x = t, y = exp6$pt_error, type = "p")
abline(exp1$y_intercept, exp1$slope, col = "cyan")
abline(exp2$y_intercept, exp2$slope, col = "cyan")
abline(exp3$y_intercept, exp3$slope, col = "cyan")
abline(exp4$y_intercept, exp4$slope, col = "cyan")
abline(exp5$y_intercept, exp5$slope, col = "cyan")
abline(exp6$y_intercept, exp6$slope, col = "cyan")
abline(exp1$y_intercept_error, exp1$slope_error, col = "orange")
abline(exp2$y_intercept_error, exp2$slope_error, col = "orange")
abline(exp3$y_intercept_error, exp3$slope_error, col = "orange")
abline(exp4$y_intercept_error, exp4$slope_error, col = "orange")
abline(exp5$y_intercept_error, exp5$slope_error, col = "orange")
abline(exp6$y_intercept_error, exp6$slope_error, col = "orange")
slopes = c(exp1$slope,exp2$slope,exp3$slope,exp4$slope,exp5$slope,exp6$slope)
slopes_error = c(exp1$slope_error,exp2$slope_error,exp3$slope_error,exp4$slope_error,exp5$slope_error,exp6$slope_error)
substrates = c(exp1$s, exp2$s,exp3$s,exp4$s,exp5$s,exp6$s)
plot(x = substrates, y = slopes, col = "orange")
lines(x = substrates, y = slopes_error, type = "p", col = "cyan")

df = data.frame(substrates, slopes, slopes_error)
for(i in 1:len(df.index)){
  s_new = c(df$substrates, as.numeric(input$s_ex))
}

y = slopes
s = substrates
v_max = exp1$vapp
km = exp1$kmapp
curve(v_max * x/(km + x), 0, exp1$s, add = TRUE, type = "l", lwd = 2, lty = 2, col = "red")
# nls(slopes~v_max * s/(km + s))

