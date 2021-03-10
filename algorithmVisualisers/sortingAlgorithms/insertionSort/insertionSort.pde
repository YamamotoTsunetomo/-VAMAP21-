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
    float key = values[index];
    int j = 0;
    for (j = index -1; j>=0 && values[j] > key; --j) {
      values[j+1] = values[j];
    }
    values[j + 1] = key; 
  } else {
    println("sorting completed");
    noLoop();
  }
  index++;
  stroke(255);
  for(int i = 0; i < values.length; ++i)
    line(i, height, i, height - values[i]);
}
