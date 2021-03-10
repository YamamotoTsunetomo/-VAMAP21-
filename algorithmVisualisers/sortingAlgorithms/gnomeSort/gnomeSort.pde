float[] values;
int index = 0;

void setup() {
  size(800,500);
  values = new float[width];
  for (int i = 0; i < values.length; ++i) 
    values[i] = random(300);
}


void draw() {
  background(0);
  if (index < values.length) {
    if (index == 0)
      index++;
    if (values[index] >= values[index - 1])
      index++;
    else {
      stroke(255,0,0);
      line(index-1,height,index-1,height-values[index-1]);
      line(index,height,index,height-values[index]);
      float tmp = values[index];
      values[index] = values[index - 1];
      values[index - 1] = tmp;
      index--;
    }
  } else {
    println("sorting completed");
    noLoop();
  }
  
  stroke(255);
  for (int i = 0; i < values.length; ++i)
    line(i, height, i, height - values[i]);
}
