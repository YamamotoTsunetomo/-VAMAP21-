
import java.util.*;

    int cols = 25;
    int rows = 25;
    int width2, height2;
    Cell[][] map = new Cell[rows][cols];
    List<Cell>openSet = new ArrayList<Cell>();
    List<Cell>closedSet = new ArrayList<Cell>();
    Cell start;
    Cell end;
    List<Cell> path = new LinkedList<Cell>();
    
    
    public void setup() {
      size(500,500);
        width2 = width / cols;
        height2 = height / rows;


        //MAKING 2D ARRAY
        for(int k = 0; k<cols; k++) {
            for(int j = 0; j<rows; j++) {
                map[k][j] = new Cell(k,j);
            }
        }
        //ADDING NEIGHBOURS
        for(int k = 0; k<cols; k++) {
            for(int j = 0; j<rows; j++) {
                map[k][j].addNeighbours(map);
            }
        }
        
        start = map[0][0];
       // end = map[(int)random(0,cols-1)][(int)random(0,rows-1)];
        end = map[cols - 1][rows - 1];
        start.wall = false;
        end.wall = false;
        openSet.add(start);
    }
    public float heuristic(Cell a, Cell b) {
        
       return dist(a.x,a.y,b.x,b.y); //RETURNS THE DISTANCE BETWEEN A AND B
       
    }


    public void draw() {
      Cell current = null;
        if(openSet.size() > 0) {
            int lowestIndex = 0;
            for(int k = 0; k < openSet.size(); k++) {
                if(openSet.get(k).f < openSet.get(lowestIndex).f) {
                    lowestIndex = k;
                }
            }
              current = openSet.get(lowestIndex);
            if(current == end) {
              noLoop();
               System.out.println("Its done boyyy");
               System.out.println(end);
            }

            openSet.remove(current);
            closedSet.add(current);

            for(Cell neighbour : current.neighbours) {
                if(!closedSet.contains(neighbour) && !neighbour.wall) {
                    int temp = current.g + 1;
                    boolean betterPath = false;
                    if(openSet.contains(neighbour)) {
                        if(neighbour.g > temp) {
                            neighbour.g = temp;
                            betterPath = true;
                        }
                    }
                    else {
                         neighbour.g = temp;
                         betterPath = true;
                         openSet.add(neighbour);
                    }
                    if(betterPath) {
                    neighbour.h = heuristic(neighbour,end);
                    neighbour.f = neighbour.h + neighbour.g;
                    neighbour.parent = current;
                    }
                }
            }
        }
        else {
          //NO SOLUTION
            System.out.println("NO SOLUTION FOUND");
            noLoop();
            return;
        }
        background(255);

        for(int k = 0; k<cols; k++) {
            for(int j = 0; j<rows; j++) {
                map[k][j].show(255,255,255);
            }
        }
        
        //DRAWING ALREADY BEEN THERE SPACES
        for (Cell cell : closedSet) {
            cell.show(255, 0, 0);
        }
        
        //DRAWING AVAILABLE SPACES
        for (Cell cell : openSet) {
            cell.show(0, 255, 0);
        }
        
        
        
        //FIND THE PATH EVERY TIK
        path = new LinkedList<Cell>();
        Cell temp = current;
               path.add(temp);
              while(temp.parent!=null) {
                path.add(temp.parent);
                temp = temp.parent;
              }
        
        //DRAWING PATH
        for (Cell cell : path) {
            cell.show(0, 0, 255);
        }
        
        noFill();
        stroke(255,0,200);
        strokeWeight(width2/2);
        beginShape();
        for (Cell cell : path) {
            vertex(cell.x*width2 + width2/2,cell.y*height2 + height2/2);
        }
        
        endShape();
    }

    public class Cell {
        private final int x;
        private final int y;
        private float f = 0;
        private int g = 0;
        private float h = 0;
        private final List<Cell> neighbours = new ArrayList<Cell>();
        private Cell parent = null;
        private boolean wall = false;


        public Cell(int x, int y) {
            this.x = x;
            this.y = y;
        if(random(1) < 0.4) {
          wall = true;
        }
        }
        public void show(int R,int G, int B) {
            fill(R,G,B);
            if(this.wall) {
              fill(0);
              noStroke();
              //rect(this.x*width2,this.y*height2, width2-1,height2-1);
            ellipse(this.x*width2 + width2/2,this.y*height2 + height2/2, width2/2,height2/2);
            }
        }
        public void addNeighbours(Cell[][] map) {
            if(x < cols-1) neighbours.add(map[x+1][y]);
            if(x > 0) neighbours.add(map[x-1][y]);
            if(y < rows-1) neighbours.add(map[x][y+1]);
            if(y > 0) neighbours.add(map[x][y-1]);
            if(x > 0 && y > 0) neighbours.add(map[x-1][y-1]);
            if(x < cols - 1 && y > 0) neighbours.add(map[x+1][y-1]);
            if(x > 0 && y < rows - 1) neighbours.add(map[x-1][y+1]);
            if(x < cols - 1 && y < rows - 1) neighbours.add(map[x+1][y+1]);
        }
        public String toString() {
            return "Cell{" +
                    "x=" + x +
                    ", y=" + y +
                    ", f=" + f +
                    ", g=" + g +
                    ", h=" + h +
                     '}';
        }
    }

   
