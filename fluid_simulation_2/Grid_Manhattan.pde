class DistanceField {

  Cell_Distance_Field[][] cellManh;

  float cellSizerW, cellSizerY;

  int indexCol, indexRow;

  public DistanceField() {

    indexCol = (width+(radiusInt*4))/radiusInt;
    indexRow = (height+(radiusInt*2))/radiusInt;

    cellManh = new Cell_Distance_Field[indexCol][indexRow];

    //println(cellManh.length);
    for (int i = 0; i < cellManh.length; i++) {

      for (int j = 0; j < cellManh[i].length; j++) {
        cellManh[i][j] =  new Cell_Distance_Field((i-2)*radius, j * radius, radius);
        //println("indexCol: " + i + " indexRow: " + j);
        //println("pos.x: " + (i-2)*radius + " pos.y: " + j * radius);

        if (i < 5 || i > cellManh.length-6 || j > cellManh[i].length-6) {
          cellManh[i][j].setToWhite();
        }
      }
    }

    //println("About to generate white dist");
    generateDistanceFieldWhite();
    //println("About to generate black dist");
    generateDistanceFieldBlack();

    setAllNormals();
  }


  private void generateDistanceFieldWhite() {

    ArrayList <Cell_Distance_Field> s = new ArrayList<Cell_Distance_Field>();
    int v = 0;

    for (int i = 0; i < cellManh.length; i ++) {
      for (int j = 0; j < cellManh[i].length; j++) {

        //if(this one is white)..
        if (cellManh[i][j].getColor() == true) {
          //Check if we have a black neighbor
          if (checkNeighborColors(i, j)) {
            s.add(cellManh[i][j]);
          }
        }
      }
    }

    while (!s.isEmpty()) {

      for (int i = 0; i < s.size(); i ++) {

        s.get(i).setManhattan(v);
        //println("index: " + i + "position of white set cell x: " + s.get(i).pos.x + " and y: " + s.get(i).pos.y);
      }

      s = neighborsManhattanList(true, s);
      //s.clear();
      v+=1;
    }
  }



  private void generateDistanceFieldBlack() {

    ArrayList <Cell_Distance_Field> s = new ArrayList<Cell_Distance_Field>();
    int v = 0;

    for (int i = 0; i < cellManh.length; i ++) {
      for (int j = 0; j < cellManh[i].length; j++) {

        //if(this one is white)..
        if (cellManh[i][j].getColor()) {
          //Check if we have a black neighbor
          if (checkNeighborColors(i, j)) {

            s.add(cellManh[i][j]);
          }
        }
      }
    }

    while (!s.isEmpty()) {

      for (int i = 0; i < s.size(); i ++) {

        s.get(i).setManhattan(v);
      }

      s = neighborsManhattanList(false, s);
      //s.clear();
      v-=1;
    }
  }

  //---------------------- Gives back a list of immediate neighbors eithe black or 
  //-----------------------white that have not been set and that are of the same color

  private ArrayList <Cell_Distance_Field> neighborsManhattanList(boolean white, ArrayList <Cell_Distance_Field> s) {

    ArrayList <Cell_Distance_Field> temp = new ArrayList<Cell_Distance_Field>();

    for (int i = 0; i < cellManh.length; i ++) {
      for (int j = 0; j < cellManh[i].length; j++) {

        for (int w = 0; w < s.size(); w++) {

          //If this cell[][] is the same as the one in the current edge
          if (cellManh[i][j].equals(s.get(w))) {

            //-------------------Store all neighboors horizontally-----------------/
            if (i == 0) {
              if (cellManh[i + 1][j].hasBeenSet == false && cellManh[i + 1][j].getColor() == white) {
                temp.add(cellManh[i + 1][j]);
              }
            } else if (i == cellManh.length-1) {
              if (cellManh[i - 1][j].hasBeenSet == false && cellManh[i + 1][j].getColor() == white) {
                temp.add(cellManh[i - 1][j]);
              }
            } else if (i > 0 && i < cellManh.length-1) {

              if (cellManh[i - 1][j].hasBeenSet == false && cellManh[i - 1][j].getColor() == white) {
                temp.add(cellManh[i - 1][j]);
              }

              if (cellManh[i + 1][j].hasBeenSet == false && cellManh[i + 1][j].getColor() == white) {
                temp.add(cellManh[i + 1][j]);
              }
            }

            if (j == 0) {
              if (cellManh[i][j+1].hasBeenSet == false && cellManh[i][j+1].getColor() == white) {
                temp.add(cellManh[i][j+1]);
              }
            } else if (j == cellManh[i].length-1) {
              if (cellManh[i][j-1].hasBeenSet == false && cellManh[i][j-1].getColor() == white) {
                temp.add(cellManh[i][j-1]);
              }
            } else {
              if (cellManh[i][j-1].hasBeenSet == false && cellManh[i][j-1].getColor() == white) {
                temp.add(cellManh[i][j-1]);
              }

              if (cellManh[i][j+1].hasBeenSet == false && cellManh[i][j+1].getColor() == white) {
                temp.add(cellManh[i][j+1]);
              }
            }
          }
        }
      }
    }
    s.clear();
    return temp;
  }

  //--------------Check a white cell has a back neighbor--------------//

  private boolean checkNeighborColors(int x, int y) {

    //println("index i: " + x + " index j: " + y);
    //println("position of white set cell x: " + cellManh[x][y].pos.x + " and y: " + cellManh[x][y].pos.y);

    if (x == 0) {
      if (cellManh[x+1][y].getColor() == false) {
        //println("if x == 0, take x+1, y");
        return true;
      }
    } else if (x == indexCol-1) {
      if (cellManh[x-1][y].getColor() == false) {
        //println("if x == indexCol-1, take x-1, y");
        return true;
      }
    } else {

      if (cellManh[x-1][y].getColor() == false || cellManh[x+1][y].getColor() == false) {
        //println("ELSE (no x == 0 || x== indexCol - 1, take both and if any of them are black");
        return true;
      }
    }

    if (y == 0) {
      if (cellManh[x][y+1].getColor() == false) {
        //println("if y == 0");
        return true;
      }
    } else if (y == indexRow-1) {
      //println("y == indexRow-1");
      if (cellManh[x][y-1].getColor() == false) {
        return true;
      }
    } else {
      //println("ELSE (no y == 0 || y == indexCol - 1, take both and if any of them are black");
      if (cellManh[x][y-1].getColor() == false || cellManh[x][y+1].getColor() == false) {
        return true;
      }
    }

    return false;
  }


  //--------------------- Set the normals to all points in the grid ----------------------//
  public void setAllNormals() {

    for (int i = 0; i < cellManh.length; i ++) {
      for (int j = 0; j < cellManh[i].length; j++) {

        cellManh[i][j].setNormal(calculateNormal(i, j));
      }
    }
  }
  
  

  public PVector calculateNormal(int indexI, int indexJ) {

    PVector UijIndex = new PVector();

    UijIndex = (cellManh[indexI][indexJ].getColor()? getIndexeWhiteToEdge(indexI, indexJ) : getIndexeBlackToEdge(indexI, indexJ));

    int edgeIndexI = (int)UijIndex.x;
    int edgeIndexJ = (int)UijIndex.y;

    //println("edge index: " + edgeIndexI + " " + edgeIndexJ);
    //println("edge index: " + cellManh[edgeIndexI][edgeIndexJ].pos);
    PVector Uij = PVector.sub(cellManh[edgeIndexI][edgeIndexJ].pos, cellManh[indexI][indexJ].pos);
    //println("Uij: " + Uij);
    Uij.normalize();
    
    Uij.mult(cellManh[indexI][indexJ].getManhattan());
    
    Uij.normalize();
    return Uij;
  }


  //---------------------Give back index to the nearest edge------------------------//

  public PVector getIndexeBlackToEdge(int indexI, int indexJ) {

    int currentDistance = cellManh[indexI][indexJ].getManhattan();

    if (currentDistance == 0) {
      return new PVector(indexI, indexJ);
    }

    if (indexI < cellManh.length - 1) {
      if (cellManh[indexI + 1][indexJ].getManhattan() > currentDistance) {
        return getIndexeBlackToEdge(indexI + 1, indexJ);
      }
    }

    if (indexI > 0) {
      if (cellManh[indexI - 1][indexJ].getManhattan() > currentDistance) {
        return getIndexeBlackToEdge(indexI - 1, indexJ);
      }
    }


    if (indexJ < cellManh[indexI].length-1) {
      if (cellManh[indexI][indexJ+1].getManhattan() > currentDistance) {
        return getIndexeBlackToEdge(indexI, indexJ + 1);
      }
    }

    if (indexJ > 0) {
      if (cellManh[indexI][indexJ-1].getManhattan() > currentDistance) {
        return getIndexeBlackToEdge(indexI, indexJ - 1);
      }
    }

    println("Return itself");
    return new PVector(indexI, indexJ);
  }

  public PVector getIndexeWhiteToEdge(int indexI, int indexJ) {

    int currentDistance = cellManh[indexI][indexJ].getManhattan();

    if (currentDistance == 0) {
      return new PVector(indexI, indexJ);
    }

    if (indexI < cellManh.length - 1) {
      if (cellManh[indexI + 1][indexJ].getManhattan() < currentDistance) {
        return getIndexeWhiteToEdge(indexI + 1, indexJ);
      }
    }

    if (indexI > 0) {
      if (cellManh[indexI - 1][indexJ].getManhattan() < currentDistance) {
        return getIndexeWhiteToEdge(indexI - 1, indexJ);
      }
    }

    if (indexJ < cellManh[indexI].length-1) {

      if (cellManh[indexI][indexJ+1].getManhattan() < currentDistance) {
        return getIndexeWhiteToEdge(indexI, indexJ + 1);
      }
    }

    if (indexJ > 0) {
      if (cellManh[indexI][indexJ-1].getManhattan() < currentDistance) {
        return getIndexeWhiteToEdge(indexI, indexJ - 1);
      }
    }

    println("Return itself");
    return new PVector(indexI, indexJ);
  }


  public void drawGrid() {
    for (int i = 0; i < cellManh.length; i++) {
      for (int j = 0; j < cellManh[i].length; j++) {
        cellManh[i][j].drawCell();
      }
    }
  }


//--------------------------- Methods to be used outside the class --------------------------//

  public PVector getIndex(PVector pos) {

    int indexI = int(constrain((pos.x + (radiusInt*2)) / radius, 0, indexCol -1));
    int indexJ = int(constrain((pos.y) / radius, 0, indexRow -1));

    return new PVector(indexI, indexJ);
  }

  public int getDistance(PVector indexo) {
    PVector indexer = indexo.copy();
    int i = int(indexer.x);
    int j = int(indexer.y);
    return cellManh[i][j].getManhattan();
  }
  
  //public int getDistance(PVector pos) {
 
  //  PVector indexer = getIndex(pos).copy();
  //  int i = int(indexer.x);
  //  int j = int(indexer.y);
    
  //  return cellManh[i][j].getManhattan();
  //}

  public PVector getNormal(PVector indexo) {
    PVector indexer = indexo.copy();
    int i = int(indexer.x);
    int j = int(indexer.y);
    return cellManh[i][j].getNormal();
  }
}