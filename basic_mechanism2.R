basic_mechanism2 = function (e = 50, s = 100, es = 0, p = 0,
                            prob_a = 80, prob_b = 50, prob_c = 5, 
                            cycles = 500){
  marbles = e + s + es + p
  time = seq(0,cycles)
  
  id_marble = seq(1:marbles)
  id_prob = seq(1:100)
  
  e_count = rep(e, cycles + 1)
  s_count = rep(s, cycles + 1)
  es_count = rep(es, cycles + 1)
  p_count = rep(p, cycles + 1)
  total_count = rep(marbles, cycles + 1)
  
  jar = c(rep("E", e), rep("S", s), rep("ES", es), rep("P", p))
  
  for(i in 2:(cycles+1)){
    pick_marbles = sample(id_marble, 2)
    pick_prob = sample(id_prob, 1)
    while(NA %in% jar[pick_marbles]){
      pick_marbles = sample(id_marble, 2)
    }
    draw_marbles = c(jar[pick_marbles[1]], jar[pick_marbles[2]])
    if("E" %in% draw_marbles & "S" %in% draw_marbles & pick_prob <= prob_a){
      jar[pick_marbles[1]] = "ES"
      #chagne one of the elements to NA
      jar[pick_marbles[2]] = NA
    }
    else if("ES" %in% draw_marbles & pick_prob <= prob_b){
      if(jar[pick_marbles[1]] == "ES"){
        jar[pick_marbles[1]] = "E"
      }
      else{
        jar[pick_marbles[2]] = "E"
      }
      #add an additional element which is produced by the separation of ES to the box
      if(anyNA(jar)){
        jar[which(is.na(jar))[1]] == "S"
      }
      else{
        jar = c(jar, "S")
      }
      
    }
    # the range of prob_b should not overlap with the range of prob_c  
    else if("ES" %in% draw_marbles & pick_prob >= (100-prob_c)){
      if(jar[pick_marbles[1]] == "ES"){
        jar[pick_marbles[1]] = "E"
      }
      else{
        jar[pick_marbles[2]] = "E"
      }
      if(anyNA(jar)){
        jar[which(is.na(jar))[1]] == "P"
      }
      else{
        jar = c(jar, "P")
      }
    }
    
    e_count[i] = length(which(jar == "E"))
    s_count[i] = length(which(jar == "S"))
    es_count[i] = length(which(jar == "ES"))
    p_count[i] = length(which(jar == "P"))
    total_count[i] = length(jar)
  }
  
  # return results of simulation
  out = list("time" = time,
             "e_count" = e_count,
             "s_count" = s_count,
             "es_count" = es_count,
             "p_count" = p_count,
             "total_count" = total_count)
  
}