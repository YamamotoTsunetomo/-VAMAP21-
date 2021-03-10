class Draggables{
  
  PVector[] point;
  int[] stack;
  int draggedPoint = -1;
  float radius;
  boolean[] locked;
  
  Draggables(PVector[] p, float radius){
    point = p;
    stack = new int[p.length];
    locked = new boolean[p.length];
    for(int i=0; i<p.length; i++){
      stack[i] = i;
      locked[i] = false;
    }
    this.radius = radius;
  }
  
  float getX(int i){
    return point[i].x;
  }
  float getY(int i){
    return point[i].y;
  }
  
  PVector getPoint(int i){
    return point[i];
  }
  
  void setX(float x, int i){
    point[i].x = x;
  }
  void setY(float y, int i){
    point[i].x = y;
  }
  
  void lock(int i){
    locked[i] = true;
  }
  void unlock(int i){
    locked[i] = false;
  }
  
  int size(){
    return point.length;
  }
  
  void update(){
    float mx = mouseX;
    float my = mouseY;
    if(mousePressed){
      for(int k=(stack.length-1); k>-1; k--){
        int i = stack[k];
        if(!locked[i]){
          if(draggedPoint == -1){
            if(dist(point[i].x, point[i].y, mx, my) <= radius){
              draggedPoint = i;
              moveToLast(k);
            }
          }else if(mx>0 && my>0 && mx<width && my<(height)){
              point[draggedPoint].x = mx;
              point[draggedPoint].y = my;
          }
        }
      }
    }
  }
  
  void redraw(){
    for(int i=0; i<point.length; i++){
      ellipse(point[stack[i]].x, point[stack[i]].y, radius, radius);
    }
  }
  
  void release(){
    draggedPoint = -1;
  }
  
  void moveToLast(int i){
    int temp = stack[i];
    for(int k=i; k<(stack.length-1); k++){
      stack[k] = stack[k+1];
    }
    stack[stack.length-1] = temp;
  }
}
