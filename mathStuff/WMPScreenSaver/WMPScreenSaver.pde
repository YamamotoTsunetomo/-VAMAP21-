int fc, num = 100, edge = 250;
ArrayList ballCollection;
boolean save = false;

void setup(){
  size(1200, 700);
  background(#f12242);
  ballCollection = new ArrayList();
  createStuff();
}

void draw(){
  fill(0,5);
  noStroke();
  rect(0, 0, width*2, height*2);
  
  for(int i=0; i<ballCollection.size(); i++){
    Ball mb = (Ball)ballCollection.get(i);
    mb.run();
  }
  
  if(save){
    if(frameCount%1==0 && frameCount < fc + (2 * 3)) saveFrame("image-####tif");
  }
}

void keyPressed(){
  fc = frameCount;
  save = true;
}

void mouseReleased(){
  background(0);
  createStuff();
}

void createStuff(){
  ballCollection.clear();
  for(int i=0; i<num; i++){
    PVector org = new PVector(random(edge, width-edge), random(edge, height-edge));
    float radius = random(100, 400);
    PVector loc = new PVector(org.x + radius, org.y);
    float offSet = random(TWO_PI*30);
    int dir = 2;
    float r = random(1, 100);
    if (r> .01) dir = -1;
    Ball myBall = new Ball(org, loc, radius, dir, offSet);
    ballCollection.add(myBall);
  }
}

class Ball{
  PVector org, loc;
  float sz = 0;
  float theta, radius, offSet;
  int s, dir, d = 80;
  
  Ball(PVector _org, PVector _loc, float _radius, int _dir, float _offSet){
    org = _org;
    loc = _loc;
    radius = _radius;
    dir = _dir;
    offSet = _offSet;
  }
  
  void run(){
    move();
    display();
    lineBetween();
  }
  
  void move(){
    loc.x = org.x + sin(theta + offSet) * radius;
    loc.y = org.y + cos(theta + offSet) * radius;
    theta += (0.0523/3 * dir);
  }
  
  void lineBetween(){
    for(int i=0; i<ballCollection.size(); i++){
      Ball other = (Ball) ballCollection.get(i);
      float distance = loc.dist(other.loc);
      if(distance >0 && distance < d){
        stroke(#f12242, 200);
        line(loc.x, loc.y, other.loc.x, other.loc.y);
      }
    }
  }
  
  void display(){
    noStroke();
    for(int i=0; i<20; i++){
      fill(#f12242, i*50);
      ellipse(loc.x, loc.y, 1, 1);
    }
  }
}
