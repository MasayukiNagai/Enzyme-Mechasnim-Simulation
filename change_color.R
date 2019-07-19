change_color = function(i){

  #make a color gradation according to a value
  if(i >= 0 & i < 1){
    r = (i - 1)^4 * 225 / 255
    g = (1 - i) * 245 / 255
    b = (1 - i^4) * 255 / 255
    out = rgb(r, g, b)
  }
  else if(i < 0){
    out = rgb(225/255, 245/255, 255/255)
  }
  else{
    out = rgb(0, 0, 0)
  }
  
  out
}
