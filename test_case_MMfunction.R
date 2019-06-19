#test case2

setwd("~/DePauw/Summer2019/Enzyme")
library(stats4)
library(splines)
library(VGAM)
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


lambertMM = function(s = 150, solvent = 150, 
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

lambertMM2 = function(s = 1, e = 0.02, 
                     pinf = 0.9818, k1 = 1000, k_1 = 950, k2 = 50, time = 20){
  t = seq(0, time, 0.1)
  pinf = pinf * s
  km = (k_1 + k2)/k1
  v = k2 *e
  kmapp = km * 1
  vapp = v * 1
  pt = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * t)/kmapp)})
  pt_error = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - (vapp + rnorm(1+t, mean = 0, sd = 0.1)) * t)/kmapp)})
  v_init = lm(pt[0:10]~t[0:10])
  slope = v_init$coefficient[2]
  y_intercept = v_init$coefficient[1]
  
  out = list("pt" = pt,
             "pt_error" = pt_error,
             "t" = t,
             "time" = time,
             "pinf" = pinf,
             "vapp" = vapp,
             "kmapp" = kmapp,
             "k1" = k1,
             "k_1" = k_1,
             "k2"  = k2,
             "s" = s,
             "e" = e,
             "slope" = slope,
             "y_intercept" = y_intercept)
}

# exp1 = lambertMM(s = 1000, solvent = 0)
# exp2 = lambertMM(s = 900, solvent = 0)
# exp3 = lambertMM(s = 800, solvent = 0)
# exp4 = lambertMM(s = 50, solvent = 0)
# exp5 = lambertMM(s = 300, solvent = 0)
# exp6 = lambertMM(s = 100, solvent = 0)
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


exp1 = lambertMM2(s = 5, e = 0.02)
exp2 = lambertMM2(s = 4, e = 0.02)
exp3 = lambertMM2(s = 3, e = 0.02)
exp4 = lambertMM2(s = 2, e = 0.02)
exp5 = lambertMM2(s = 1, e = 0.02)
exp6 = lambertMM2(s = 0, e = 0.02)
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
slopes = c(exp1$slope,exp2$slope,exp3$slope,exp4$slope,exp5$slope,exp6$slope)
substrates = c(exp1$s, exp2$s,exp3$s,exp4$s,exp5$s,exp6$s)

plot(x = substrates, y = slopes)
