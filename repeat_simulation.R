source("basic_mechanism.R")
repeat_simulation = function(reps = 10,
                             e = 50, s = 100, es = 0, p = 0,
                             prob_a = 80, prob_b = 30, prob_c = 5,
                             cycles = 500){
  rep_results = replicate(reps, basic_mechanism(e, s, es, p, prob_a, prob_b, prob_c, cycles), simplify = FALSE)
  e_reps = as.data.frame(lapply(rep_results, "[", "e_count"))
  s_reps = as.data.frame(lapply(rep_results, "[", "s_count"))
  es_reps = as.data.frame(lapply(rep_results, "[", "es_count"))
  p_reps = as.data.frame(lapply(rep_results, "[", "p_count"))
  
  e_average = apply(e_reps, 1, mean)
  s_average = apply(s_reps, 1, mean)
  es_average = apply(es_reps, 1, mean)
  p_average = apply(p_reps, 1, mean)
  
  out = list("repeats" = reps,
             "time" = rep_results[[1]]$time,
             "cycles" = rep_results[[1]]$cycles,
             "e_reps" = e_reps,
             "s_reps" = s_reps,
             "es_reps"= es_reps,
             "p_reps" = p_reps,
             "e_average" = e_average,
             "s_average" = s_average,
             "es_average" = es_average,
             "p_average" = p_average)
}