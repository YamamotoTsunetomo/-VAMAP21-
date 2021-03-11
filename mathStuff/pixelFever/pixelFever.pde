//final int AGE_MAX = 95;
//final static float RANDOM_MAX = 1;

class Spreader{
  float X, Y, Xnew, Ynew;
  int age;
  final int AGE_MAX = 95;
final static float RANDOM_MAX = 1;
  Spreader(){
    rebirth();
  }
  
  public void rebirth(){
    X = random(-RANDOM_MAX, RANDOM_MAX);
    Y = random(-RANDOM_MAX, RANDOM_MAX);
    age = 0;
  }
  
  public void update(){
    Xnew = sin(aa*Y) - cos(bb*X);
    Ynew = sin(cc*X) - cos(dd*Y);
    
    int pixelX = (int)((Xnew/ZOOM_VALUE + .5) * min(width, height));
    int pixelY = (int)((Ynew/ZOOM_VALUE + .5) * min(width, height));
    stroke(0, 10);
    if(-1 < pixelX && pixelX < width-1 && -1 < pixelY && pixelY < height-1){
      tabPixels[pixelX][pixelY] += 1;
    }
    
    X = Xnew + random(-0.105, 0.105);
    Y = Ynew + random(-0.105, 0.105);
    
    age++;
    if(age > AGE_MAX){
      rebirth();
    }
  }
}
