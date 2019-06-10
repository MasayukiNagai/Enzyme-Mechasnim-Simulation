#test case
ptm = proc.time()

setwd("~/DePauw/Summer2019/Enzyme")
source("basic_mechanism.R")
# source("basic_mechanism2.R")
source("simple_plot.R")
source("repeat_simulation.R")
source("rep_plot.R")

e = 50
s = 100
es = 1
p = 1
prob_a = 80
prob_b = 50
prob_c = 5
cycles = 5000
reps = 10

file = basic_mechanism(e, s, es, p, prob_a, prob_b, prob_c, cycles)
simple_plot(file)

# rep_file = repeat_simulation(reps, e, s, es, p, prob_a, prob_b, prob_c, cycles)
# rep_plot(rep_file)

proc.time() - ptm