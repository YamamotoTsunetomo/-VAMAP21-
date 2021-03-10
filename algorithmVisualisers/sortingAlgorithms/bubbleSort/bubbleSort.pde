float[] values;
int i = 0;
int j = 0;

void setup() {
  size(800,500);
  values = new float[width];
  for (int i = 0; i < values.length; ++i)
    values[i] = random(200);
  
}

void draw() {
  background(0);
  if (i < values.length) {
      if (values[j] > values[j + 1]) {
        stroke(255,0,0);
        line(j,height,j,height-values[j]);
        line(j+1,height,j+1,height-values[j+1]);
        float tmp = values[j];
        values[j] = values[j + 1];
        values[j + 1] = tmp;
      }
  } else {
    println("sorting completed.");
    noLoop();
  }
  j++;
  if (j == values.length - 1 - i) {
    i++;
    j = 0;
  }
  stroke(255);
  for (int n = 0; n < values.length; ++n) {
    line(n, height, n, height - values[n]);
  }
}
