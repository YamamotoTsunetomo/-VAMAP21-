Draggables p;
float radius = 15;
GenCircle[] five;
PVector incentre;
color red, yellow, blue;
int depth;
boolean showPerpendicular, showApollonian, showDots;

void setup(){
  size(700, 700);
  ellipseMode(RADIUS);
  strokeWeight(4);
  
  PVector[] points = new PVector[3];
  points[0] = new PVector( round(0.5*width), round( 0.3*height) );
  points[1] = new PVector( round(0.3*width), round( 0.7*height) );
  points[2] = new PVector( round(0.7*width), round( 0.7*height) );
  p = new Draggables(points, radius);
  five = new GenCircle[5];
  depth = 5;
  showPerpendicular = true;
  showApollonian = true;
  showDots = true;
}

void draw(){
  blue   = color(  0,  52, 103, 500 - 10*depth);
  red    = color(255,  70,  70, 500 - 30*depth);
  yellow = color(255, 180,  80, 500 - 10*depth);
  background(255);
  p.update();
  makeThreeCircles();
  makeFiveCircles();
  if(five[3] != null && five[4] != null){
    if(showApollonian){
      stroke(blue);
      for(int i = 0; i < 4; i++){
        if(!five[i].isLine){
          five[i].redraw();
        }
      }
    }
    GenCircle[] four = { five[0], five[1], five[2], five[4] };
    if(five[3].r>1){
      if(showApollonian){
        five[4].redraw();
      }
      makeTree(four, depth);
      four[3] = five[3];
      makeTree(four, depth);
    }
  }
  if(showDots){
    stroke(220, 50, 80);
    fill(255, 220, 220);
    p.redraw();
    noFill();
  }
}

void keyReleased(){
  if(keyCode >= 48 && keyCode <= 57){
    depth = keyCode - 48;
  }
  if(key == 'a' || key == 'A'){
    showApollonian = !showApollonian;
  }
  if(key == 'd' || key == 'D'){
    showDots = !showDots;
  }
  if(key == 'p' || key == 'P'){
    showPerpendicular = !showPerpendicular;
  }
  if(key == 's' || key == 'S'){
    saveFrame("a-###.png");
  }
}

void makeTree(GenCircle[] c, int depth){
  for(int i = 0; i < 3; i++){
    PVector i1 = intersectCircles(c[i], c[3]);
    PVector i2 = intersectCircles(c[i], c[(i+1)%3]);
    PVector i3 = intersectCircles(c[(i+1)%3], c[3]);
    if(i1 != null && i2 != null && i3 != null){
      GenCircle perpC = new GenCircle(i1, i2, i3);
      if(showPerpendicular){
        stroke(yellow);
        perpC.redraw();
      }
      GenCircle newC = reflectCircle(perpC, c[(i+2)%3]);
      if(newC.r > 2 && depth > 0){
        if(showApollonian){
          stroke(blue);
          if(!newC.isLine){
            newC.redraw();
          }
        }
        GenCircle[] newFour = { c[i], c[(i+1)%3], c[3], newC };
        makeTree(newFour, depth-1);
      }
    }
  }
}

void makeThreeCircles(){
  GenCircle[] bisector = new GenCircle[2];
  for(int i = 0; i < 2; i++){
    float a1 = atan2(p.getY(i+1)     - p.getY(i), p.getX(i+1)     - p.getX(i));
    float a2 = atan2(p.getY((i+2)%3) - p.getY(i), p.getX((i+2)%3) - p.getX(i));
    bisector[i] = new GenCircle(p.getPoint(i), p.getPoint(i), 
                                new PVector(p.getX(i)+cos((a1+a2)/2), 
                                            p.getY(i)+sin((a1+a2)/2)));
  }
  incentre = bisector[0].intersect(bisector[1])[0];
  GenCircle[] perp = new GenCircle[2];
  for(int i = 0; i < 2; i++){
    perp[i] = new GenCircle(incentre, incentre, 
                            new PVector(incentre.x+(p.getY(i+1)-p.getY(i)), 
                                        incentre.y-(p.getX(i+1)-p.getX(i))));                            
  }
  GenCircle segment = new GenCircle(p.getPoint(0), p.getPoint(0), p.getPoint(1));
  PVector p1 = perp[0].intersect(segment)[0];
  segment = new GenCircle(p.getPoint(1), p.getPoint(1), p.getPoint(2));
  PVector p2 = perp[1].intersect(segment)[0];
  five[0] = new GenCircle(p.getPoint(0), dist(p.getPoint(0).x, p.getPoint(0).y, p1.x, p1.y));
  five[1] = new GenCircle(p.getPoint(1), dist(p.getPoint(1).x, p.getPoint(1).y, p1.x, p1.y));
  five[2] = new GenCircle(p.getPoint(2), dist(p.getPoint(2).x, p.getPoint(2).y, p2.x, p2.y));
}

void makeFiveCircles(){
  PVector[] intersect = new PVector[3];
  GenCircle[] segment = new GenCircle[3];
  for(int i = 0; i < 3; i++){
    float a = atan2(p.getY((i+1)%3) - p.getY(i), p.getX((i+1)%3) - p.getX(i));
    intersect[i] = intersectCircles(five[(i+1)%3], five[i]);
    segment[i] = new GenCircle(five[i].m, five[i].m, five[(i+1)%3].m);
  }
  PVector[][] bluePoint = new PVector[3][2];
  for(int i = 0; i < 3; i++){
    GenCircle perp = new GenCircle(p.getPoint(i), p.getPoint(i),
                                   new PVector(p.getPoint(i).x+(p.getY((i+1)%3)-p.getY((i+2)%3)),
                                               p.getPoint(i).y-(p.getX((i+1)%3)-p.getX((i+2)%3))));
    bluePoint[i] = perp.intersect(five[i]);
  }
  PVector[][] redPoint = new PVector[3][2];
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < 2; j++){
      GenCircle line = new GenCircle(bluePoint[i][j], bluePoint[i][j], intersect[(i+1)%3]);
      PVector[] temp = line.intersect(five[i]);
      if(temp != null){
        redPoint[i][j] = dist(temp[0].x, temp[0].y, bluePoint[i][j].x, bluePoint[i][j].y) < 0.001 ? temp[1] : temp[0];
      }else{
        five[3] = null;
        five[4] = null;
        return;
      }
    }
  }
  for(int i = 0; i < 3; i++){
    if(dist(redPoint[i][0].x, redPoint[i][0].y, incentre.x, incentre.y) > dist(redPoint[i][1].x, redPoint[i][1].y, incentre.x, incentre.y)){
      PVector temp = redPoint[i][0];
      redPoint[i][0] = redPoint[i][1];
      redPoint[i][1] = temp;
    }
  }
  five[3] = new GenCircle(redPoint[0][0], redPoint[1][0], redPoint[2][0]);
  five[4] = new GenCircle(redPoint[0][1], redPoint[1][1], redPoint[2][1]);
}

PVector intersectCircles(GenCircle c1, GenCircle c2){
  if(c1 != null && c2 != null){
    if(c1.isLine || c2.isLine){
      GenCircle line = c1.isLine ? c1 : c2;
      GenCircle circ = c1.isLine ? c2 : c1;
      GenCircle temp = new GenCircle(circ.m, circ.r*2);
      PVector[] tint = temp.intersect(line);
      if(tint != null){
        return new PVector((tint[0].x+tint[1].x)/2, (tint[0].y+tint[1].y)/2);
      }
    }else{
      float a = atan2(c2.m.y - c1.m.y, c2.m.x - c1.m.x);
      float d = dist(c2.m.x, c2.m.y, c1.m.x, c1.m.y);
      if(d > 0){
        if(d < c2.r){
          if(c1.r < c2.r){
            return new PVector(c2.m.x + c2.r*(c1.m.x-c2.m.x)/d, c2.m.y + c2.r*(c1.m.y-c2.m.y)/d);
          }else{
            return new PVector(c2.m.x - c2.r*(c1.m.x-c2.m.x)/d, c2.m.y - c2.r*(c1.m.y-c2.m.y)/d);
          }
        }else if(d < c1.r){
          if(c2.r < c1.r){
            return new PVector(c1.m.x + c1.r*(c2.m.x-c1.m.x)/d, c1.m.y + c1.r*(c2.m.y-c1.m.y)/d);
          }else{
            return new PVector(c1.m.x - c1.r*(c2.m.x-c1.m.x)/d, c1.m.y - c1.r*(c2.m.y-c1.m.y)/d);
          }
        }else{
            return new PVector(c1.m.x + c1.r*(c2.m.x-c1.m.x)/d, c1.m.y + c1.r*(c2.m.y-c1.m.y)/d);
        }
      }
    }
  }
  return null;
}

GenCircle reflectCircle(GenCircle r, GenCircle c){
  if(c.isLine){
    PVector r1 = r.reflect(c.p1);
    PVector r2 = r.reflect(c.p2);
    return new GenCircle(r1, r1, r2);
  }else{
    PVector p1 = new PVector(c.m.x + c.r, c.m.y);
    PVector p2 = new PVector(c.m.x, c.m.y + c.r);
    PVector p3 = new PVector(c.m.x, c.m.y - c.r);
    return new GenCircle(r.reflect(p1), r.reflect(p2), r.reflect(p3));
  }
}

void mouseReleased(){
  p.release();
}
