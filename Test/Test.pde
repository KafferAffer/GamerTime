int gamestate = 0;

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;

ArrayList<Boundary> boundaries;

void setup(){
  size(500,800);
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

void keyPressed(){
  dir(key);
}
void keyReleased(){
  nodir(key);
}
