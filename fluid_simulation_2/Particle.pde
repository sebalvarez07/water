class Particle {

  PVector prevPos, pos, vel;

  int prevCol, prevRow, currentCol, currentRow;

  float prevP = 0;

  final int MASS = 20;

  //ArrayList < ArrayList <Particle> > neighbors = new ArrayList <ArrayList <Particle>>();

  ArrayList <Particle> neighbors = new ArrayList <Particle>();


  public Particle(float x, float y) {
    pos = new PVector(x, y);
    prevPos = new PVector();
    vel = new PVector();

    currentCol = int(constrain((pos.x / radiusInt), 0, colIndex-1));
    currentRow = int(constrain((pos.y / radiusInt), 0, rowIndex-1));

    prevCol = currentCol;
    prevRow = currentRow;
  }

  public void displayParticle() {
    
    colorMode(HSB, 255);
    color c = color(prevP * 20, 126, 255, 150);
    
    noStroke(); 
    fill(c);
    ellipse(pos.x, pos.y, MASS, MASS);
    
    /*
    stroke(255);
    noFill();
    ellipse(pos.x, pos.y, MASS, MASS);*/
  }


  public void advancePosition() {
    prevPos = pos.copy();
    vel.mult(timeStep);
    pos.add(vel);
  }


  public void updateVel() {
    vel = PVector.sub(pos, prevPos).div(timeStep);
  }


  public boolean indexUpdate() {

    currentCol = int(constrain((pos.x / radiusInt), 0, colIndex-1));
    currentRow = int(constrain((pos.y / radiusInt), 0, rowIndex-1));

    if (currentCol != prevCol || currentRow != prevRow) {
      return true;
    }

    return false;
  }
  
  public void addNeighbor(Particle p) {
    neighbors.add(p);
  }
}