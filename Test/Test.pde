
int gamestate = 0;
float scroll;
PVector Obstaclesize = new PVector(50, 200);
float ObstacleFreq = 2.1;

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
Player p;
Box2DProcessing box2d;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
Button start = new Button(new PVector(250, 500), new PVector(200, 100), "start");

void setup() {
  size(500, 800);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);

  //SpilSetup();
  Startsetup();
}

void draw() {
  switch(gamestate) {
  case 0:
    Start();
    break;
  case 1:
    Spil();
    break;
  }
}

void mousePressed() {
  switch(gamestate) {
  case 0:
    StartButton();
    break;
  case 1:
    break;
  }
  
}

void keyPressed() {
  switch(gamestate) {
    case 0:
  
      break;
    case 1:
      p.dir();
      break;
  }
}
void keyReleased() {
  switch(gamestate) {
    case 0:
  
      break;
    case 1:
      p.dir();
      break;
  }
}
