void Spil(){
  clear();
  background(144,192,107);
  Vec2 pos = box2d.getBodyPixelCoord(p.body);
  println("WHY:  "+pos.y);
  box2d.step();
  scroll();
  
  update();
  randomObs();
  p.done();
  fill(0);
  textAlign(LEFT);
  text("score:   "+int(score),20,30);
}

void scroll(){
  while(p.y<400-scroll){
    scroll += speed;
    randomObs();
    score += speed;
  }
  scroll += speed;
  speed += 0.0001;
  score += speed;
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
    float sizeX =  random(Obstaclesize.x*2,Obstaclesize.y*2);
    float sizeY =  random(Obstaclesize.x,Obstaclesize.y);
    obstacles.add(new Obstacle(random(width),-50-scroll-sizeY,sizeX,sizeY));
  }
}
