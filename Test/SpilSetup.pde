void SpilSetup(){
  for(int i = 0; i<height; i++){
    float spawn = random(100);
    if(spawn<ObstacleFreq){
      obstacles.add(new Obstacle(random(width),i,random(Obstaclesize.x,Obstaclesize.y),random(Obstaclesize.x,Obstaclesize.y)));
    }
  }
  p = new Player(width/2,height/6,10);
}



void Startsetup(){
  clear();
  background(144,192,107);
  start.show();
  textAlign(CENTER);
  textSize(32);
  fill(0, 102, 153);
  text("SlingClimb",width/2,100);
}
