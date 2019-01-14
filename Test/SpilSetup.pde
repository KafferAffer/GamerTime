void SpilSetup(){
  for(int i = 0; i<height; i++){
    float spawn = random(100);
    if(spawn<ObstacleFreq){
      obstacles.add(new Obstacle(random(width),i,random(Obstaclesize.x,Obstaclesize.y),random(Obstaclesize.x,Obstaclesize.y)));
    }
  }
}



void Startsetup(){
  clear();
  background(144,192,107);
  
  
  
  textAlign(CENTER);
  textSize(32);
  fill(0, 102, 153);
  text("SlingClimb",width/2,100);
}
