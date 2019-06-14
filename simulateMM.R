simulateMM = function(e = 20, s_axis = 500,
                      k1 = 100, k_1 = 20, k2 = 0.05){
  s = seq(0,s_axis,0.1)
  km = (k_1 + k2)/k1
  v_init = (k2 * e/100 * s/100)/(km + s/100)
  
  out = list("s_axis" = s_axis,
             "v_init" = v_init,
             "s" = s)
}