int gamestate = 0;
void setup(){

}

void draw(){
  switch(gamestate){
    case 0:
      Start();
      break;
    case 1:
      Spil();
      break;
  }
  
  
}
