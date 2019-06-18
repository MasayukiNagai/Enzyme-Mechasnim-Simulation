#test case
# ptm = proc.time()

setwd("~/DePauw/Summer2019/Enzyme")
source("basic_mechanism.R")
source("basic_mechanism2.R")
source("simple_plot.R")
source("repeat_simulation.R")
source("rep_plot.R")
source("simulateMM.R")
source("plotMM.R")
source("simple_simulation.R")
source("rep_simple_simulation.R")
source("rep_simple_plot.R")

e = 10
s = 150
es = 0
p = 0
prob_a = 100
prob_b = 20
prob_c = 5
cycles = 1000
reps = 10
solvent = 150
k1 = 100
k_1 = 0
k2 = 100


file = basic_mechanism(e, s, es, p, prob_a, prob_b, prob_c, cycles)
simple_plot(file)

rep_file = repeat_simulation(reps, e, s, es, p, prob_a, prob_b, prob_c, cycles)
rep_plot(rep_file)

simfile = simulateMM()
plotMM(simfile)
# 
# exp1 = simple_simulate(300, 0)
# exp2 = simple_simulate(200, 100)
# exp3 = simple_simulate(150, 150)
# exp4 = simple_simulate(100, 200)
# exp5 = simple_simulate(50, 250)
# matplot(x = exp1$time, y = exp1$p_count, type = "l", lwd = 3, col = "red",
#         xlab = "Time", ylab = "P")
# lines(x = exp2$time, y = exp2$p_count, lwd = 3, col = "orange")
# lines(x = exp3$time, y = exp3$p_count, lwd = 3, col = "yellowgreen")
# lines(x = exp4$time, y = exp4$p_count, lwd = 3, col = "green")
# lines(x = exp5$time, y = exp5$p_count, lwd = 3, col = "blue")
# x = exp1$time
# y = exp1$p_count
# line11 = lm(y[1:100]~x[1:100])
# line12 = lm(y[101:200]~x[101:200])
# line13 = lm(y[201:300]~x[201:300])
# line14 = lm(y[301:400]~x[301:400])
# abline(line11[1], line11[2], col = "cyan")
# abline(line12[1], line12[2], col = "dodgerblue")
# abline(line13[1], line13[2], col = "blue")
# abline(line14[1], line14[2], col = "navy")

# exp1 = rep_simple_simulation(reps, 100, 50)
# exp2 = rep_simple_simulation(reps, 200, 100)
# exp3 = rep_simple_simulation(reps, 400, 200)
# exp4 = rep_simple_simulation(reps, 1000, 500)
# exp5 = rep_simple_simulation(reps, 300, 0)
# rep_simple_plot(exp1)
# rep_simple_plot(exp2)
# rep_simple_plot(exp3)
# rep_simple_plot(exp4)
# rep_simple_plot(exp5)
# matplot(x = exp1$time, y = exp1$p_average, type = "l", lwd = 3, col = "red",
#         xlab = "Time", ylab = "P")
# lines(x = exp2$time, y = exp2$p_average, lwd = 3, col = "orange")
# lines(x = exp3$time, y = exp3$p_average, lwd = 3, col = "yellowgreen")
# lines(x = exp4$time, y = exp4$p_average, lwd = 3, col = "green")
# lines(x = exp5$time, y = exp5$p_average, lwd = 3, col = "blue")
# x = exp1$time
# y = exp1$p_average
# line11 = lm(y[1:100]~x[1:100])
# line12 = lm(y[101:200]~x[101:200])
# line13 = lm(y[201:300]~x[201:300])
# line14 = lm(y[301:400]~x[301:400])
# line15 = lm(y[401:500]~x[401:500])
# abline(line11$coefficients[1], line11$coefficients[2], col = "cyan")
# abline(line12$coefficients[1], line12$coefficients[2], col = "dodgerblue")
# abline(line13$coefficients[1], line13$coefficients[2], col = "blue")
# abline(line14$coefficients[1], line14$coefficients[2], col = "navy")
# abline(line15$coefficients[1], line15$coefficients[2], col = "green")

  
# proc.time() - ptm