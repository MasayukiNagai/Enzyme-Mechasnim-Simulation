lambertMM = function(file, e = 0.02, i = 0.30,
                     k1 = 1000, k_1 = 950, k2 = 50, ki1 = 0.20, ki2 = 0.15,
                     pinf_ratio = 0.9818, time = 20, sd = 0,
                     game = c("Normal", "Competitive", "Uncompetitive", "Mixed")){
  
  e = e * 10^(-6)

  game = match.arg(game)
  t = seq(0, time, length.out = 40)
  km = (k_1 + k2)/k1
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

  pt = rep(list(character(length(t))), length(file$substrates))
  pt_error = rep(list(character(length(t))), length(file$substrates))
  # tangent_lines = rep(list(list()), length(file$substrartes))
  # tangent_lines_errors = rep(list(list()), length(file$substrartes))
  slopes = as.numeric(character(length(file$substrates)))
  slopes_error = as.numeric(character(length(file$substrates)))
  intercepts = as.numeric(character(length(file$substrates)))
  intercepts_error = as.numeric(character(length(file$substrates)))
  if(length(file$substrates) != 0){
    for(i in 1:length(file$substrates)){
      s = file$substrates[i]
      pinf = pinf_ratio * s
      pt[[i]] = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * t)/kmapp)})
      pt_error[[i]] = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * t)/kmapp)}) + rnorm(t, mean = 0, sd = 0.00)
      v_init = lm(pt[[i]][0:3]~t[0:3])
      slopes[i] = as.numeric(v_init$coefficient[2])
      intercepts[i] = as.numeric(v_init$coefficient[1])
      v_init_error = lm(pt_error[[i]][0:3]~t[0:3])
      slopes_error[i] = as.numeric(v_init_error$coefficient[2])
      intercepts_error[i] = as.numeric(v_init_error$coefficient[1])
    }
    pt = as.data.frame(matrix(unlist(pt), nrow = length(unlist(pt[1]))))
    pt_error = as.data.frame(matrix(unlist(pt_error), nrow = length(unlist(pt_error[1]))))
  }
  
  
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
             "substrates" = file$substrates,
             "e" = e,
             "i" = i,
             # "tangent_lines" = tangent_lines,
             # "tangent_lines_errors" = tangent_lines_errors
             "slopes" = slopes,
             "intercepts" = intercepts,
             "slopes_error" = slopes_error,
             "intercepts_error" = intercepts_error
  )
}