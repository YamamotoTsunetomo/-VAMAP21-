float x, y, x2, y2, rad, rad2, dist, dist2;
float deg, incr, yIn, rotateBy, ang;

void setup(){
  size(800, 800);
  background(255);
  incr = 3;
  rad = -20;
  rad2 = -160;
  dist = 800;
  dist2 = 250;
}

void draw(){
  noStroke();
  fill(#02021A, 4);
  rect(0, 0, width, height);
  fill(random(0, 255), 255, 255); 
  rotateBy += .02;
  pushMatrix();
  translate(width/2, height/2);
  rotate(rotateBy);
  deg = 0;
  while(deg <= 360){
    deg += incr;
    ang = radians(deg);
    x = cos(ang) * (rad + (dist * noise(y/100, yIn)));
    y = sin(ang) * (rad + (dist * noise(x/80, yIn)));
    ellipse(x, y, 1.5, 1.5);
    x2 = sin(ang) * (rad2 + (dist2 * noise(y2/20, yIn)));
    y2 = cos(ang) * (rad2 + (dist2 * noise(y2/20, yIn)));
   ellipse(x2, y2, 1, 1);
  }
  yIn += .01;
  popMatrix();
}
