void SpilSetup(){
  scroll = 0;
  speed=0.1;
  score = 0;
  for(int i = 0; i<height; i++){
    float spawn = random(100);
    if(spawn<ObstacleFreq/2){
      obstacles.add(new Obstacle(random(width),i,random(Obstaclesize.x*2,Obstaclesize.y*2),random(Obstaclesize.x,Obstaclesize.y)));
    }
  }
  p = new Player(width/2,height/2,10);
  f = 10;
  particles.add(new Particle(width/2,height/2,4));
  Grab(particles.get(0).body,f*5);
  grapped = true;
  pointed = true;
}



void startSetup(){
  clear();
  background(144,192,107);
  start.show();
  textAlign(CENTER);
  textSize(32);
  fill(0, 102, 153);
  text("SlingClimb",width/2,100);
}
