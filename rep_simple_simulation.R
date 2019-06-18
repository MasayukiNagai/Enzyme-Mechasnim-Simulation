source("simple_simulation.R")
rep_simple_simulation = function(reps = 10,
                                 s = 150, solvent = 150, 
                                 k1 = 100, k_1 = 0, k2 = 100, cycles = 1000){
  rep_results = replicate(reps, simple_simulation(s, solvent, k1, k_1, k2, cycles), simplify = FALSE)
  s_reps = as.data.frame(lapply(rep_results, "[", "s_count"))
  es_reps = as.data.frame(lapply(rep_results, "[", "es_count"))
  p_reps = as.data.frame(lapply(rep_results, "[", "p_count"))
  
  s_average = apply(s_reps, 1, mean)
  es_average = apply(es_reps, 1, mean)
  p_average = apply(p_reps, 1, mean)
  
  x = rep_results[[1]]$time
  y = p_average
  line1 = lm(y[1:100]~x[1:100])
  line2 = lm(y[101:200]~x[101:200])
  line3 = lm(y[201:300]~x[201:300])
  line4 = lm(y[301:400]~x[301:400])
  line5 = lm(y[401:500]~x[401:500])
  slopes = c(line1$coefficients[2], line2$coefficients[2], line3$coefficients[2], line4$coefficients[2], line5$coefficients[2])
  coeffs = c(line1$coefficients[1], line2$coefficients[1], line3$coefficients[1], line4$coefficients[1], line5$coefficients[1])
  maxline = which(slopes == max(slopes))
  
  out = list("repeats" = reps,
             "time" = rep_results[[1]]$time,
             "s_reps" = s_reps,
             "es_reps"= es_reps,
             "p_reps" = p_reps,
             "s_average" = s_average,
             "es_average" = es_average,
             "p_average" = p_average,
             "slope" = slopes[maxline[1]],
             "coeff" = coeffs[maxline[1]])
}