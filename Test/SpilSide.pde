void Spil(){
  clear();
  background(144,192,107);
  box2d.step();
  scroll();
  update();
  randomObs();
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
  p.display();
  p.move();
  
  
  float px = mouseX-p.x;
  float py = mouseY-p.y-scroll;
  PVector hi = new PVector(px,py);
  float dist = hi.mag();
  hi = hi.div(dist);
  
  
  int f = 0;
  while(abs(f) < 90){
    float lx = p.x+f*hi.x*5;
    float ly = p.y+scroll+f*hi.y*5;
    ellipse(lx,ly,5,5);
    for(Obstacle wall: obstacles){
      if(wall.checksides(lx,ly)){
        f = 90;
      }
    }
    f++;
    
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
