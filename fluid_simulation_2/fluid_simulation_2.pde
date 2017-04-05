float radius = 30;

int radiusInt = (int)radius;

int colIndex, rowIndex;

float timeStep = 0.01666;

ParticleManager pm;

void setup() {
  size(1600, 900);

  colIndex = width / radiusInt;
  rowIndex = height / radiusInt;
  
  pm = new ParticleManager();
}

void draw() {
  background(0);
  pm.update();
}

void mouseClicked() {
  
  pm.mouseClicked();
}

void mouseDragged() {
  pm.mouseDragged();
}