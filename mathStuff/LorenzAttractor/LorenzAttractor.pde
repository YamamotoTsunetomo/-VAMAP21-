import peasy.*;
float x=1;
float y=0;
float z=0;
float deg=0;
float a=10;
float b=28;
float c=8.0/3.0;

ArrayList<PVector> points= new ArrayList<PVector>();
PeasyCam cam;

public void settings() {
  size(1200,1080, P3D);  
}

void setup(){
 background(0);
 colorMode(HSB);
cam=new PeasyCam(this, 1000);
}


void draw(){
  background(0);
      float dt=0.01; 
      float dx=a*(y-x)*dt;
      float dy=(x*(b-z)-y)*dt;
      float dz=(x*y-c*z)*dt;
      
        x=x+dx;
        y=y+dy;
        z=z+dz;
        
        points.add(new PVector(x,y,z));
          translate(0,0,-80);
          scale(8);
          strokeWeight(0.5);
          noFill();
          float Color=0;
        beginShape();
        for(PVector v:points){
          stroke(Color,255,255);
          vertex(v.x,v.y,v.z);
          Color=(Color>255)?0:Color+0.2;
                }
        endShape();
}
