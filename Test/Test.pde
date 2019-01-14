int gamestate = 1;
float scroll;
PVector Obstaclesize = new PVector(50,200);
float ObstacleFreq = 1;

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

void setup(){
  size(500,800);
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);
  
  SpilSetup();
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
