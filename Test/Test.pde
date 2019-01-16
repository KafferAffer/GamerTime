int gamestate = 0;
float scroll,score,speed=0.1;
PVector Obstaclesize = new PVector(10, 50);

float ObstacleNorFreq = 1.5;
float ObstacleFreq = ObstacleNorFreq;
boolean grapped = false;
boolean pointed = false;
float lx,ly;

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.dynamics.contacts.*;

Player p;
Box2DProcessing box2d;
float f;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Particle> particles = new ArrayList<Particle>();
Button start = new Button(new PVector(250, 500), new PVector(200, 100), "start");

void setup() {
  size(1000, 800);

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -50);

  //SpilSetup();
  startSetup();
  
  SpilSetup();
  //Startsetup();
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

void killAll(){
  println("kiling " + obstacles.size());
  for(int i = obstacles.size()-1; i>0;i--){
    //println(obstacles.size());
    obstacles.get(i).killBody();
    obstacles.remove(i);
    
  }
  p.killBody();
  removePoint();
  gamestate = 0;
  startSetup();
  SpilSetup();
}

void mousePressed() {
  switch(gamestate) {
  case 0:
    StartButton();
    break;
  case 1:
    if(mouseButton == LEFT){
      grapple();    
    }else{
      removePoint();
    }
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
      p.nodir();
      break;
  }
}
