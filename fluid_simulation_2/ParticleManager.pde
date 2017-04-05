
class ParticleManager {

  Grid grid = new Grid();

  DistanceField distanceField;

  float collisionRadius;

  float p0 = 5.52;
  float oGreek = 10;
  float bGreek = 0;
  float k = 200;
  float kNear = 501.0;

  PVector gravity;

  float friction = 0.01;
  float collisionSoftness = 0.4;
  
  ArrayList<Particle> particlesAll = new ArrayList <Particle>();

  public ParticleManager() {

    gravity = new PVector(0, 10);
  }


  public void applyExternalForces(ArrayList<Particle> particles) {
     for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);

      p.vel.add(gravity);
    }
  }

  public void applyViscocity( ArrayList<Particle> particles) {

    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);

      //for each particle n that belongs to p's neighbor list
      for (int j = 0; j < p.neighbors.size(); j ++) {

        Particle n = p.neighbors.get(j);

        PVector Vpn = PVector.sub(n.pos, p.pos);
        float VELinward = PVector.sub(p.vel, n.vel).dot(Vpn);

        if (VELinward > 0) {

          float Length = Vpn.mag();
          VELinward = VELinward/Length;
          Vpn.normalize();

          float q = Length/radius;
          PVector I = PVector.mult(Vpn, ((0.5 * timeStep * (1 - q)) * ((oGreek * VELinward) + (bGreek * (VELinward*VELinward)))));
          p.vel.sub(I);
        }
      }
    }
  }

  public void advanceParticles(ArrayList<Particle> particles) {
     for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      p.advancePosition();

      grid.moveParticle(p);
    }
  }

  public void updateNeighbors(ArrayList<Particle> particles) {
    
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);

      p.neighbors.clear();

      ArrayList<Particle> possibleNeighbors = grid.possibleNeighbors(p);

      for (int j = 0; j < possibleNeighbors.size(); j++) {
        Particle n = possibleNeighbors.get(j);

        float distanceMag = PVector.sub(p.pos, n.pos).mag();

        if (distanceMag < radius) {
          p.addNeighbor(n);
        }
      }
    }
  }

  public void doubleDensityRelaxation(ArrayList<Particle> particles) {
 
    for (int i = 0; i < particles.size(); i++) {
      Particle pa = particles.get(i);

      float p = 0;
      float pNear = 0;
      float tempN = 0;
      //for each particle n that belongs to p's neighbor list
      for (int j = 0; j < pa.neighbors.size(); j ++) {
        Particle n = pa.neighbors.get(j);

        tempN =  PVector.sub(pa.pos, n.pos).mag();
        float q = 1.0 - (tempN / radius);
        p = p + (q*q);
        pNear = pNear + (q*q*q);
      }

      pa.prevP = p;
      float P = k * (p - p0);
      float Pnear = kNear + pNear;
      PVector delta = new PVector(0, 0);

      for (int j = 0; j < pa.neighbors.size(); j ++) {
        Particle n = pa.neighbors.get(j);
        tempN = PVector.sub(pa.pos, n.pos).mag();
        float q = 1.0 - (tempN / radius);
        PVector Vpn = PVector.sub(n.pos, pa.pos).div(tempN);
        PVector D = PVector.mult(Vpn, (0.5 * (timeStep * timeStep) * ((P * q) + (Pnear * (q*q) ) ) ));
        n.pos.add(D);
        delta.sub(D);
      }
      pa.pos.add(delta);
    }
  }


  public void resolveCollisionsY(  ArrayList<Particle> particles) {
 
    float center = width/2;
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);


      float toParticle = p.pos.x - center;
      float mag = (toParticle < 0 ? toParticle * -1 : toParticle);

      //This is a hack to add some noise into the collision behaviour.
      //It makes the particles less likely to align perfectly and get stuck.
      float adjustRadius = (i % 9 - 3) * 0.9;
      //float adjustRadius = 0;


      //println("adjustRadius " + adjustRadius);

      if (mag > (width/2) +  adjustRadius) {
        toParticle *= (1 / mag);
        float penetration = mag - ( (width/2) + adjustRadius); 
        toParticle *= (penetration * 0.5);


        p.pos.x -= toParticle;
      }
    }
  }

  public void mouseRepulse(ArrayList<Particle> particles) {

    PVector mouse = new PVector(mouseX, mouseY);
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      
      PVector toParticle = PVector.sub(p.pos, mouse);
      float dist = toParticle.mag();
      
      if(dist < 10) {
        toParticle.mult(10/dist);
        p.pos.add(toParticle);
      }
    }
  }

  public void resolveCollisionsX(ArrayList<Particle> particles) { 

    float topEdge = 0;
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);


      float toParticle = p.pos.y - topEdge;
      float mag = (toParticle < 0 ? toParticle * -1 : toParticle);

      //This is a hack to add some noise into the collision behaviour.
      //It makes the particles less likely to align perfectly and get stuck.
      float adjustRadius = (i % 9 - 3) * 0.9;
      //float adjustRadius = 0;


      //println("adjustRadius " + adjustRadius);

      if (mag > (height-10) +  adjustRadius) {

        toParticle *= (1 / mag);
        float penetration = mag - ( (height-10) + adjustRadius); 
        toParticle *= (penetration * 0.5);

        //println("to particle " + toParticle);

        p.pos.y -= toParticle;
      }
    }
  }

  public void updateVelocity(ArrayList<Particle> particles) {
     for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      p.updateVel();
      p.displayParticle();
    }
  }

  public void update() {

    if (keyPressed) {
      if (key == 's' || key == 'S') 
        gravity = new PVector(0, 10);
      if (key == 'w' || key == 'W') 
        gravity = new PVector(0, -10);
      if (key == 'a' || key == 'A') 
        gravity = new PVector(-10, 0);
      if (key == 'd' || key == 'D') 
        gravity = new PVector(10, 0);   
      if (key == 'f' || key == 'F') 
        gravity = new PVector(0, 0);
    } 
    
    particlesAll = grid.getAllParticles();

    applyExternalForces(particlesAll);
    applyViscocity(particlesAll);
    advanceParticles(particlesAll);
    updateNeighbors(particlesAll);
    doubleDensityRelaxation(particlesAll);
    //resolveCollisions();
    resolveCollisionsX(particlesAll);
    resolveCollisionsY(particlesAll);
    mouseRepulse(particlesAll);
    updateVelocity(particlesAll);
  }

  public void mouseClicked() {

    Particle p = new Particle(mouseX, mouseY);
    grid.addParticleToCell(p);
  }

  public void mouseDragged() {

    Particle p = new Particle(mouseX, mouseY);
    grid.addParticleToCell(p);
  }
}