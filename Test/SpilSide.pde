void Spil(){
  clear();
  background(144,192,107);
  box2d.step();
  scroll();
  update();
  randomObs();
}

void scroll(){
  scroll += speed;
  speed += 0.0001;
}

void update(){
  for (int i = obstacles.size()-1; i >= 0; i--) {
    Obstacle b = obstacles.get(i);
    b.display();
    if (b.checkDeath()) {
      obstacles.remove(i);
    }
  }
  p.display();
  p.move();
  for(Particle pa: particles){
    pa.display();
    Grab(particles.get(0).body,f*5);
  }
  updatePoint();
}

void randomObs(){
  float spawn = random(100);
  if(spawn<ObstacleFreq*speed){
    float sizeX =  random(Obstaclesize.x,Obstaclesize.y);
    float sizeY =  random(Obstaclesize.x,Obstaclesize.y);
    obstacles.add(new Obstacle(random(width),-50-scroll-sizeY,sizeX,sizeY));
  }
}
