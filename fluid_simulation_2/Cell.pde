class Cell {
 
  PVector pos;

  ArrayList <Particle> particles = new ArrayList<Particle>();
  
  public Cell(float x, float y){
    
    pos = new PVector(x, y);
    
  }
  
  public void addParticle(Particle p){
    particles.add(p);
  }
  
  public void removeParticle(Particle p){
    particles.remove(p);
  }
  
  public void displayCell() {
    noFill();
    stroke(255);
    rect(pos.x, pos.y, radius, radius);
  }
}