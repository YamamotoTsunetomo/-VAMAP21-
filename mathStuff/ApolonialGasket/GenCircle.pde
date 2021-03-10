class GenCircle{
  PVector m;
  float r;
  boolean isLine;
  PVector p1, p2;
  
  GenCircle(PVector mid, float radius){
    this.m = mid;
    this.r = radius;
    this.isLine = false;
    this.p1 = null;
    this.p2 = null;
  }
  
  GenCircle(PVector p1, PVector p2, PVector p3){
    if(Math.abs(p1.x*(p2.y-p3.y) + p2.x*(p3.y-p1.y) + p3.x*(p1.y-p2.y)) <= 0.0001){
      this.isLine = true;
      if(p1.x == p2.x && p1.y == p2.y){
        this.p1 = p1;
        this.p2 = p3;
        this.m = null;
        this.r = -1;
      }else{
        this.p1 = p1;
        this.p2 = p2;
        this.m = null;
        this.r = -1;
      }
    }else{
      this.isLine = false;
      if(p2.x == p1.x){
        PVector temp = p2;
        p2 = p3;
        p3 = temp;
      }else if(p2.x == p3.x){
        PVector temp = p2;
        p2 = p1;
        p1 = temp;
      }
      float ma = (p2.y-p1.y)/(p2.x-p1.x);
      float mb = (p3.y-p2.y)/(p3.x-p2.x);
      float mx = (ma*mb*(p1.y-p3.y) + mb*(p1.x+p2.x) - ma*(p2.x+p3.x)) / (2*(mb-ma));
      float my;
      
      if(abs(mb) < abs(ma)){
        my = -1/ma*(mx-(p1.x+p2.x)/2) + (p1.y+p2.y)/2;
      }else{
        my = -1/mb*(mx-(p2.x+p3.x)/2) + (p2.y+p3.y)/2;
      }
      float rad = dist(mx, my, p2.x, p2.y);
      if(rad < 10000){
        this.r = dist(mx, my, p2.x, p2.y);
        this.m = new PVector(mx, my);
      }else{
        this.isLine = true;
        this.m = null;
        this.r = -1;
      }
      this.p1 = p1;
      this.p2 = p2;
    }
  }
  
  PVector[] intersect(GenCircle c){
    PVector[] arr = new PVector[2];
    if(this.isLine && c.isLine){
      float num = (c.p2.y-c.p1.y)*(this.p1.x-   c.p1.x) - (c.p2.x-c.p1.x)*(this.p1.y-   c.p1.y);
      float den = (c.p2.x-c.p1.x)*(this.p2.y-this.p1.y) - (c.p2.y-c.p1.y)*(this.p2.x-this.p1.x);
      if(den != 0){
        PVector pv = new PVector(this.p1.x + (this.p2.x - this.p1.x)*num/den,
                                 this.p1.y + (this.p2.y - this.p1.y)*num/den);
        arr[0] = pv;
        arr[1] = pv;
      }else{
        return null;
      }
    }else if( (this.isLine && !c.isLine) || (!this.isLine && c.isLine) ){
      GenCircle circ = this.isLine ? c    : this;
      GenCircle lin  = this.isLine ? this : c;
      
      float x1 = lin.p1.x -circ.m.x;
      float y1 = lin.p1.y -circ.m.y;
      float x2 = lin.p2.x -circ.m.x;
      float y2 = lin.p2.y -circ.m.y;
      float dx = x2 - x1;
      float dy = y2 - y1;
      float dr = dist(x1, y1, x2, y2);
      float determinant = x1*y2 - x2*y1;
      float discriminant = circ.r*circ.r*dr*dr - determinant*determinant;
      float ax, ay, bx, by;
      
      if(discriminant < 0){
        return null;
      }
      
      if(dy > 0){
        ax = (determinant * dy + dx * (float) Math.sqrt(discriminant)) / (dr*dr);
        bx = (determinant * dy - dx * (float) Math.sqrt(discriminant)) / (dr*dr);
      }else{
        ax = (determinant * dy - dx * (float) Math.sqrt(discriminant)) / (dr*dr);
        bx = (determinant * dy + dx * (float) Math.sqrt(discriminant)) / (dr*dr);
      }
      ay = (-determinant*dx + (float) Math.abs(dy)*(float) Math.sqrt(discriminant)) / (dr*dr);
      by = (-determinant*dx - (float) Math.abs(dy)*(float) Math.sqrt(discriminant)) / (dr*dr);
      arr[0] = new PVector(ax + circ.m.x, ay + circ.m.y);
      arr[1] = new PVector(bx + circ.m.x, by + circ.m.y);
    }else{
      float d = dist(this.m.x, this.m.y, c.m.x, c.m.y);
      if(d == 0 || d > (this.r + c.r)){
        return null;
      }
      float a = (this.r*this.r - c.r*c.r + d*d) / 2 / d;
      float h = (float) Math.sqrt(this.r*this.r - a*a);
      float px = this.m.x + a*(c.m.x-this.m.x) / d;
      float py = this.m.y + a*(c.m.y-this.m.y) / d;
      float p3x = px + h*(c.m.y-this.m.y) / d;
      float p3y = py - h*(c.m.x-this.m.x) / d;
      float p4x = px - h*(c.m.y-this.m.y) / d;
      float p4y = py + h*(c.m.x-this.m.x) / d;
      arr[0] = new PVector(p3x, p3y);
      arr[1] = new PVector(p4x, p4y);
    }
    return arr;
  }
  
  GenCircle tangent(PVector p){
    if(this.isLine){
      return this;
    }else{
      return new GenCircle(p, new PVector(p.x-(p.y-this.m.y), p.y-(this.m.x-p.x)), p);
    }
  }
  
  PVector reflect(PVector p){
    float a, b;
    if(isLine){
      float d = dist(this.p1.x, this.p1.y, this.p2.x, this.p2.y);
      float nx = (this.p2.x - this.p1.x)/d;
      float ny = (this.p2.y - this.p1.y)/d;
      float c = (p.x-this.p1.x)*nx + (p.y-this.p1.y)*ny;
      a = -p.x + 2*this.p1.x + 2*nx*c;
      b = -p.y + 2*this.p1.y + 2*ny*c;
    }else{
      if(dist(p.x, p.y, this.m.x, this.m.y) < 0.00001){
        return null;
      }
      a = this.m.x + this.r*this.r*(p.x-this.m.x) / ((p.x-this.m.x)*(p.x-this.m.x) + (p.y-this.m.y)*(p.y-this.m.y));
      b = this.m.y + this.r*this.r*(p.y-this.m.y) / ((p.x-this.m.x)*(p.x-this.m.x) + (p.y-this.m.y)*(p.y-this.m.y));
    }
    return new PVector(a, b);
  }
  
  void redraw(){
    if(isLine){
      float d = dist(p1.x, p1.y, p2.x, p2.y);
      if(d != 0){
        float dx = (p2.x-p1.x)/d;
        float dy = (p2.y-p1.y)/d;
        line(p1.x - 2000*dx, p1.y - 2000*dy, p1.x + 2000*dx, p1.y + 2000*dy);
      }
    }else{
      ellipse(m.x, m.y, r, r);
    }
  }
}
