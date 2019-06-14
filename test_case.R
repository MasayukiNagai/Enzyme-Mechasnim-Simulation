#test case
ptm = proc.time()

setwd("~/DePauw/Summer2019/Enzyme")
# source("basic_mechanism.R")
# source("basic_mechanism2.R")
# source("simple_plot.R")
# source("repeat_simulation.R")
# source("rep_plot.R")
source("simulateMM.R")
source("plotMM.R")

e = 10
s = 500
# es = 0
# p = 0
# prob_a = 100
# prob_b = 20
# prob_c = 5
# cycles = 50000
# reps = 10

# file = basic_mechanism(e, s, es, p, prob_a, prob_b, prob_c, cycles)
# simple_plot(file)

# file = repeat_simulation(reps, e, s, es, p, prob_a, prob_b, prob_c, cycles)
# rep_plot(rep_file)

file = simulateMM()
plotMM(file)

proc.time() - ptm