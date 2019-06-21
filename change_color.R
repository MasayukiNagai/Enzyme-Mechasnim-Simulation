change_color = function(i){
  # k = 0.8
  # if(i < k){
  #   out = rgb((1 - i/k) * 204/255, (1 - i/k) * 204/255, 1)
  # }
  # else{
  #   out = rgb(0, 0, ((1-i)/(1-k)) * 104/255 + 153/255) 
  # }
  
  r = (i - 1)^4 * 225 / 255
  g = (1 - i) * 245 / 255
  b = (1 - i^4) * 255 / 255
  out = rgb(r, g, b)
  
  out
}
