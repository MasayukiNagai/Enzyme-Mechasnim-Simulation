calc_pt = function(s, e = 10 * 10^(-6), i = 0.30,
                   k1 = 1000, k_1 = 950, k2 = 50, km = NULL, ki1 = 0.20, ki2 = 0.15,
                   time = 20, interval = 50, pinf_ratio = 0.9818, sd = 0,
                   game = c("Normal", "Competitive", "Uncompetitive", "Mixed")){
  
  game = match.arg(game)
  t = seq(0, time, length.out = 50)
  if(is.null(km)){
    km = (k_1 + k2)/ k1
  }
  v_max = k2 * e
  
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
  
  t = seq(0, time, length.out = interval)
  vapp = k2 * e
  pinf = pinf_ratio * s
  pt = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * t)/kmapp)})+ rnorm(t, mean = 0, sd = sd)
  
  pt
}