 class Cursors{
  final int MIN = -3;
  final int MAX = 3;
  final int BOX_WIDTH = 50;
  final int MARGIN = 35;
  final int TOP_MARGIN = 60;
  int LEFT_MARGIN;
  final float RAD = 3;
  
  Cursors(){
    LEFT_MARGIN = width - BOX_WIDTH - MARGIN;
  }
  
  public void update(){
    int curBox = isAboveCursors();
    if(dragging && curBox > 0 && (mouseX != pmouseX || mouseY != pmouseY)){
      if(curBox == 1){
        aa = map(mouseX, LEFT_MARGIN, LEFT_MARGIN + BOX_WIDTH, MIN, MAX);
        bb = map(mouseY, TOP_MARGIN, TOP_MARGIN + BOX_WIDTH, 0, MAX);
      }else{
        cc = map(mouseX, LEFT_MARGIN, LEFT_MARGIN + BOX_WIDTH, MIN, MAX);
        dd = map(mouseY, TOP_MARGIN + MARGIN + BOX_WIDTH, TOP_MARGIN + MARGIN + 2*BOX_WIDTH, 0, MAX);
      }
      cleanPixels();
    }
    
    stroke(100);
    fill(255);
    rect(LEFT_MARGIN, TOP_MARGIN, BOX_WIDTH, BOX_WIDTH);
    rect(LEFT_MARGIN, TOP_MARGIN + MARGIN + BOX_WIDTH, BOX_WIDTH, BOX_WIDTH);
    
    noStroke();
    fill(100);
    ellipse((int)map(aa, MIN, MAX, LEFT_MARGIN, LEFT_MARGIN + BOX_WIDTH),
            (int)map(bb, 0, MAX, TOP_MARGIN, TOP_MARGIN + BOX_WIDTH), RAD, RAD);
    ellipse((int)map(cc, MIN, MAX, LEFT_MARGIN, LEFT_MARGIN + BOX_WIDTH),
            (int)map(dd, 0, MAX, TOP_MARGIN + MARGIN + BOX_WIDTH, TOP_MARGIN + MARGIN + 2*BOX_WIDTH), RAD, RAD);
  }
  
  public int isAboveCursors(){
    int l_box = 0;
    if(LEFT_MARGIN < mouseX && mouseX < LEFT_MARGIN + BOX_WIDTH){
      if(TOP_MARGIN < mouseY && mouseY < TOP_MARGIN + BOX_WIDTH){
        l_box = 1;
      }else if(TOP_MARGIN + MARGIN + BOX_WIDTH < mouseY && mouseY < TOP_MARGIN + MARGIN + 2*BOX_WIDTH){
        l_box = 2;
      }
    }
    return l_box;
  }
  
  public void randomize(){
    println("random profile");
    aa = random(MIN, MAX);
    bb = random(0, MAX);
    cc = random(MIN, MAX);
    dd = random(0, MAX);
    updateValues();
  }
  
  private void setProfile(int pp){
    if(pp < AA.length){
      println("setProfile: " + pp);
      aa = AA[pp];
      bb = BB[pp];
      cc = CC[pp];
      dd = DD[pp];
      updateValues();
    }
  }
  
  private void updateValues(){
    cleanPixels();
    println("- - -");
    println("a: " + aa + "\nb: " + bb + "\nc: " + cc + "\nd" + dd);
  }
  
  public void transmitKey(char p_key){
    key = p_key;
    onKeyPressed();
  }
  
  private void onKeyPressed(){
    println("key: " + key);
    switch(key){
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        setProfile(int(key)-49);
        break;
      case '0':
        randomize();
        break;
      default:
        hasToInitColors = true;
        break;
    }
  }
  
}
