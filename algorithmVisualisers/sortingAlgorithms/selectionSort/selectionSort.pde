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
  if (index < values.length - 1) {
    int min = index;
    for (int j = index+1; j < values.length; ++j)
      if (values[j] < values[min])
        min = j;
    float tmp = values[min];
    values[min] = values[index];
    values[index] = tmp;
  } else {
    println("sorting completed.");
    noLoop();
  }
  index++;
  stroke(255);
  for (int i = 0; i < values.length; ++i)
    line(i, height, i, height - values[i]);
}
