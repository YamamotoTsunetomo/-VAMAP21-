final int BG_COLOR = color(0, 0, 50);

MyColor myColor;
int nbColors = 500;
color[] tabColors = new color[nbColors];
float maxValue;
public Boolean hasToInitColors = false;

Cursors myCursors;
public Boolean dragging = false;
public int currentBox = 0;

final int NB_SPREADERS = 8000;
Spreader[] spreaders = new Spreader[NB_SPREADERS];

int [][] tabPixels;
public final float[] AA = {
  random(-2, -1),  random(-1.2, -0.5), random(1.5, 2.5), random(0.3, 1)
};
public final float[] BB = {
  random(1, 2), random(2, 3), random(2, 3), random(0.2, 0.9)
};
public final float[] CC = {
  random(1, 2), random(-1.2, -0.5), random(1, 2), random(-3, -2)
};
public final float[] DD = {
  random(1, 2), random(2, 3), random(-0.5, 0.5), random(2, 3)
};

int r = (int)random(AA.length);
public float aa = AA[r];
public float bb = BB[r];
public float cc = CC[r];
public float dd = DD[r];
public final float ZOOM_VALUE = 4.2;

void setup(){

  myCursors = new Cursors();
  tabPixels = new int[width][height];
  initColors();
  for(int k=0; k<NB_SPREADERS; k++){
    spreaders[k] = new Spreader();
  }
}

void initColors(){
  background(BG_COLOR);
  myColor = new MyColor();
  for(int i=0; i<nbColors; i++){
    tabColors[i] = color(myColor.R, myColor.G, myColor.B);
    myColor.update();
  }
  tabColors[0] = BG_COLOR;
}

public void cleanPixels(){
  for(int i=0; i<width; i++){
    for(int j=0; j<height; j++){
      tabPixels[i][j] = 0;
    }
  }
}
public void settings() {
  size(800,800, "processing.opengl.PGraphics2D");
}
void draw(){
  if(hasToInitColors){
    initColors();
    hasToInitColors = false;
  }
  
  maxValue = 0;
  for(int k=0; k<NB_SPREADERS; k++){
    spreaders[k].update();
  }
  
  for(int i=0; i<width; i++){
    for(int j=0; j<height; j++){
      maxValue = max(maxValue, tabPixels[i][j]);
    }
  }
  
  maxValue = log(1 + maxValue);
  color c;
  float a;
  
  loadPixels();
  for(int i=0; i<width; i++){
    for(int j=0; j<height; j++){
      c = tabColors[int(map(log(1 + tabPixels[i][j]), 0, maxValue, 0, nbColors - 1))];
      pixels[j*width + i] = c;
    }
  }
  updatePixels();
  
  myCursors.update();
}

void keyPressed(){
  myCursors.transmitKey(key);
}

void mousePressed(){
  if(mouseButton == LEFT){
    int curBox = myCursors.isAboveCursors();
    if(curBox == 0){
      cleanPixels();
      myCursors.randomize();
    }else{
      currentBox = curBox;
      dragging = true;
    }
  }else{
    for(int k=0; k<NB_SPREADERS; k++){
      spreaders[k].rebirth();
    }
  }
}

void mouseReleased(){
  dragging = false;
}
