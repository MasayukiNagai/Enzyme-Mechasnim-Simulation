lambertPt = function(s = 1, e = 100 * 10^(-6), i = 0.30,
                     k1 = 1000, k_1 = 950, k2 = 50, km = NULL, ki1 = 0.20, ki2 = 0.15,
                     s_max = 10, pinf_ratio = 0.9818, time = 20, interval = 1000, sd = 0,
                     game = c("Normal", "Competitive", "Uncompetitive", "Mixed")){
  
  game = match.arg(game)
  t = seq(0, time, length.out = interval)
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
  
  pinf = pinf_ratio * s
  pt = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * t)/kmapp)})
  pt_error = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * t)/kmapp)}) + rnorm(t, mean = 0, sd = sd)
  v_init = lm(pt[0:50]~t[0:50])
  slopes = as.numeric(v_init$coefficient[2])
  intercepts = as.numeric(v_init$coefficient[1])
  v_init_error = lm(pt_error[0:50]~t[0:50])
  slopes_error = as.numeric(v_init_error$coefficient[2])
  intercepts_error = as.numeric(v_init_error$coefficient[1])

  pinf_max = pinf_ratio * s_max
  pt_max = pinf_max - kmapp * lambertW({(pinf_max/kmapp) * exp((pinf_max - vapp * t)/kmapp)})
  time = min(min(which(pt_max > (0.97 * pinf_max)), time) * 1.5, time)
  
  out = list("pt" = pt,
             "pt_error" = pt_error,
             "t" = t,
             "time" = time,
             "pinf_ratio" = pinf_ratio,
             "vapp" = vapp,
             "kmapp" = kmapp,
             "k1" = k1,
             "k_1" = k_1,
             "k2"  = k2,
             "ki1" = ki1,
             "ki2" = ki2,
             "s_max" = s_max,
             "s" = s,
             "e" = e,
             "i" = i,
             "slopes" = slopes,
             "intercepts" = intercepts,
             "slopes_error" = slopes_error,
             "intercepts_error" = intercepts_error
            )
}