class Grid {

  Cell[][] cells  =  new Cell[colIndex][rowIndex];
  ArrayList <Particle> particles = new ArrayList<Particle>();

  public Grid() {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {

        cells[i][j] = new Cell(i * radiusInt, j * radiusInt);
      }
    }
  }



  public void addParticleToCell(Particle p) {
    particles.add(p);
    cells[p.currentCol][p.currentRow].addParticle(p);

    if (particles.size() % 50 == 0)
      println("Num particles: " + particles.size());
  }

  public ArrayList <Particle> getAllParticles() {

    return particles;
  }



  public void displayGrid() {

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {

        cells[i][j].displayCell();
      }
    }
  }



  public void moveParticle(Particle p) {

    if (p.indexUpdate()) {

      cells[p.prevCol][p.prevRow].removeParticle(p);
      cells[p.currentCol][p.currentRow].addParticle(p);

      p.prevCol = p.currentCol;
      p.prevRow = p.currentRow;
    }
  }


  ArrayList <Particle> temp = new ArrayList<Particle>();

  public ArrayList <Particle> possibleNeighbors(Particle p) {

    //ArrayList<Particle> temp= new ArrayList <Particle>(cells[p.currentCol][p.currentRow].particles.size());
    /*
    ArrayList<Particle> temp = nineCellList(p.currentCol, p.currentRow);
     
     //for(int i = 0; i < cells[p.currentCol][p.currentRow].particles.size(); i ++)
     for (int i = 0; i < temp.size(); i ++)
     {
     
     if (temp.get(i).equals(p)) {
     temp.remove(p);
     }
     }*/
    temp.clear();
    for (int i = 0; i < particles.size(); i ++)
    {
      Particle n = particles.get(i);
      if (!n.equals(p))
        temp.add(n);
    }
    return temp;
  }

  ArrayList<Particle> temp2= new ArrayList <Particle>();

  public ArrayList <Particle> nineCellList(int x, int y) {

    int sX = x -1;
    int eX = x+1;
    if (x==0) {
      sX = 0;
    }
    if (x==colIndex-1) {
      eX= sX+1;
    }

    for (int i = sX; i <= eX; i++) {

      int sY = y-1;
      int eY = y +1;
      if (y ==0) {
        sY = 0;
      }
      if (y == rowIndex-1) { 
        eY = sY + 1;
      }

      temp2.clear();
      for (int j = sY; j <= eY; j++) {

        for (int w = 0; w < cells[i][j].particles.size(); w++) {
          temp.add(cells[i][j].particles.get(w));
        }
      }
    }
    return temp;
  }
}