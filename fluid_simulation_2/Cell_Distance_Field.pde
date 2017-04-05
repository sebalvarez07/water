class Cell_Distance_Field {

  PVector pos;

  int manhattanDistance;
  boolean isWhite = false;
  boolean hasBeenSet = false;

  float cellSize;
  
  PVector normal;

  public Cell_Distance_Field(float x, float y, float cellSize) {

    pos = new PVector(x, y);
    this.cellSize = cellSize;
  }

  public void drawCell() {

    if (isWhite) {
      fill(255);
      stroke(0);
    } else {
      fill(0);
      stroke(255);
    }

    rect(pos.x, pos.y, cellSize, cellSize);

      String s = null;
      if (isWhite) {
        fill(0);
        stroke(255);
        s = "Im w ";
      } else {
        fill(255);
        stroke(0);
        s = "Im B ";
      }

      text(manhattanDistance, pos.x, pos.y+cellSize);
    
  }

  public void setManhattan(int manh) {
    hasBeenSet = true;
    manhattanDistance = manh;
  }

  public int getManhattan() {
    return manhattanDistance;
  }

  public boolean getColor() {
    return isWhite;
  }

  public void setToWhite() {
    isWhite = true;
  }
  
  public void setNormal(PVector normal) {
    this.normal = normal;
  }
  
  public PVector getNormal() {
     return normal;
  }
  
}