void Spil(){
  clear();
  background(144,192,107);
  box2d.step();
  scroll();
  update();
  randomObs();
  println();
}

void scroll(){
  scroll++;
}

void update(){
  for (Obstacle wall: obstacles) {
    wall.display();
  }
  for (int i = obstacles.size()-1; i >= 0; i--) {
    Obstacle b = obstacles.get(i);
    if (b.checkDeath()) {
      obstacles.remove(i);
    }
  }
}

void randomObs(){
  float spawn = random(100);
  if(spawn<ObstacleFreq){
    float sizeX =  random(Obstaclesize.x,Obstaclesize.y);
    float sizeY =  random(Obstaclesize.x,Obstaclesize.y);
    obstacles.add(new Obstacle(random(width),-50-scroll-sizeY,sizeX,sizeY));
  }
}
