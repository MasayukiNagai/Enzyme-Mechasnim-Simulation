calc_slopes = function(s, e = 10 * 10^(-6), 
                       time = 20, pinf_ratio = 0.9818, kmapp = 1, k2 = 50, sd = 0){
  t = seq(0, time, length.out = 50)
  vapp = k2 * e
  pinf = pinf_ratio * s
  pt = pinf - kmapp * lambertW({(pinf/kmapp) * exp((pinf - vapp * t)/kmapp)})+ rnorm(t, mean = 0, sd = sd)
  v_init_error = lm(pt[0:3]~t[0:3])
  slope_error = as.numeric(v_init_error$coefficient[2])
  
  slope_error
}