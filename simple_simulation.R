simple_simulation = function(s = 150, solvent = 150, 
                             k1 = 100, k_1 = 0, k2 = 100, cycles = 1000){
  
  p = 0
  es = 0
  marbles = s + es + p + solvent
  time = seq(0,cycles)
    
  id_marble = seq(1:marbles)
  id_prob = seq(1:100)
    
  s_count = rep(s, cycles + 1)
  es_count = rep(es, cycles + 1)
  p_count = rep(p, cycles + 1)
  
  jar = c(rep("Sol", solvent), rep("S", s), rep("ES", es), rep("P", p))
    
  for(i in 2:(cycles+1)){
    pick_marble = sample(id_marble, 1)
    pick_prob = sample(id_prob, 1)
    if(jar[pick_marble] == "S" & pick_prob <= k1){
      jar[pick_marble] = "ES"
    }
    else if(jar[pick_marble] == "ES" & pick_prob <= k2){
      jar[pick_marble] = "P"
    }
    else if(jar[pick_marble] == "ES" & pick_prob >= (100 - k_1)){
      jar[pick_marble] = "S"
    }
    
    s_count[i] = length(which(jar == "S"))
    es_count[i] = length(which(jar == "ES"))
    p_count[i] = length(which(jar == "P"))
  }
    
    # return results of simulation
    out = list("time" = time,
               "s_count" = s_count,
               "es_count" = es_count,
               "p_count" = p_count)
    
  }  