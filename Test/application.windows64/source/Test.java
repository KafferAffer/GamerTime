import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.dynamics.joints.*; 
import org.jbox2d.collision.shapes.Shape; 
import org.jbox2d.dynamics.contacts.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Test extends PApplet {

int gamestate = 0;
float scroll,score,speed=100;
PVector Obstaclesize = new PVector(10, 50);

float ObstacleFreq = 1.5f;
boolean grapped = false;
boolean pointed = false;
float lx,ly;









Player p;
Box2DProcessing box2d;
float f;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Particle> particles = new ArrayList<Particle>();
Button start = new Button(new PVector(250, 500), new PVector(200, 100), "start");

public void setup() {
  

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

public void draw() {
  switch(gamestate) {
  case 0:
    Start();
    break;
  case 1:
    Spil();
    break;
  }
}

public void killAll(){
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
}

public void mousePressed() {
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

public void keyPressed() {
  switch(gamestate) {
    case 0:
  
      break;
    case 1:
      p.dir();
      break;
  }
}
public void keyReleased() {
  switch(gamestate) {
    case 0:
  
      break;
    case 1:
      p.nodir();
      break;
  }
}
class Button {
  PVector pos;
  PVector size;
  String text;
  Button(PVector pos_, PVector size_, String text_){
    pos = pos_;
    size = size_;
    text = text_;
  }
  public boolean click (){
    if(mouseX<pos.x+size.x/2&&pos.x-size.x/2<mouseX&&mouseY<pos.y+size.y/2&&pos.y-size.y/2<mouseY){
      return true;
    }
    return false;
  }
  public void show(){
    rectMode(CENTER);
    fill(200,200,200);
    rect(pos.x,pos.y,size.x,size.y);
    
    textAlign(CENTER);
    textSize(32);
    fill(0, 102, 153);
    text(text,pos.x,pos.y);
  }
}
public void grapple(){
  if(grapped){
    removePoint();
  }
  float px = mouseX-p.x;
  float py = mouseY-p.y-scroll;
  PVector hi = new PVector(px,py);
  float dist = hi.mag();
  hi = hi.div(dist);
  
  
  f = 0;
  int num = 0;
  grapped = false;
  pointed = false;
  while(abs(num) < 1000){
    float lx = p.x+f*hi.x*5;
    float ly = p.y+scroll+f*hi.y*5;
    ellipse(lx,ly,5,5);
    for(Obstacle wall: obstacles){
      if(wall.checksides(lx,ly)){
        particles.add(new Particle(lx,ly,4));
        num = 1000;
        grapped = true;
      }
    }
    f++;
    num++;
    
  }
}



class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  float x;
  float y;
  
  int col;

  Particle(float x_, float y_, float r_) {
    r = r_;
    x = x_;
    y = y_-scroll;
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;

    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3f;
    fd.restitution = 0.5f;
    
    body.createFixture(fd);

    col = color(175);
  }

  // This function removes the particle from the box2d world
  public void killBody() {
    box2d.destroyBody(body);
  }
  
  // Is the particle ready for deletion?
  public boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  // 
  public void display() {
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    ellipse(x,y+scroll,r*2,r*2);
    // Let's add a line so we can see the rotation
    line(x,y+scroll,p.x,p.y+scroll);
    popMatrix();
  }


}

public void Grab(Body i,float dist){
         DistanceJointDef djd = new DistanceJointDef();
         // Connection between previous particle and this one
         djd.bodyA = p.body;
         djd.bodyB = i;
         // Equilibrium length
         djd.length = box2d.scalarPixelsToWorld(dist);
         // These properties affect how springy the joint is 
         djd.frequencyHz = 30;
         djd.dampingRatio = 0;
         
         // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
         // We might need to someday, but for now it's ok
         DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
         grapped = true;
}

public void updatePoint(){
  if (particles.size()>0){pointed = true;}
  if(pointed){
    lx=particles.get(0).x;
    ly=particles.get(0).y;
    removePoint();
    particles.add(new Particle(lx,ly+scroll,4));
    if(f*5+0.2f<dist(p.x,p.y,lx,ly)){
      Grab(particles.get(0).body,f*5);
    }
  }
  println(f*5);
  println(dist(p.x,p.y,lx,ly));
}

public void removePoint(){
  for(int i = particles.size()-1; i>-1;i--){
    particles.get(i).killBody();
    particles.remove(i);
    pointed = false;
  }
}
class Obstacle {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  Obstacle(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  public void display() {
    fill(0);
    stroke(0);
    rectMode(CENTER);
    rect(x,y+scroll,w,h);
    
    
  }
  
  public boolean checkDeath() {
    // Is it off the bottom of the screen?
    if (y > height+h-scroll) {
      killBody();
      return true;
    }
    return false;
  }
  
  public void killBody() {
    box2d.destroyBody(b);
  }
  
  public boolean checksides(float lx,float ly) {
    if(lx<x+w/2&&x-w/2<lx&&ly<y+h/2+scroll&&scroll+y-h/2<ly){
      return true;
    }
    return false;
  }

}

class Player{
  
  //Player body
  Body body;
  float r;

  int col;
  
  boolean left = false;
  boolean right = false;
  boolean up = false;
  boolean down = false;
  float x,y;


  Player(float x_, float y_, float r_) {
    r = r_;
    col = color(183,183,0);
    // This function puts the Player in the Box2d world
    x = x_;
    y = y_;
    makeBody(x_, y_, r);
  }

  // This function removes the Player from the box2d world
  public void killBody() {
    box2d.destroyBody(body);
  }
  
  // Is the Player ready for deletion?
  public boolean done() {
    // Let's find the screen position of the Player
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y+scroll > height+200) {
      killAll();
      return true;
    }
    return false;
  }
  // 
  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    x=pos.x;
    y=pos.y;
    pushMatrix();
    stroke(0);
    strokeWeight(1);
    fill(col);
    ellipse(x, y+scroll, r*2, r*2);
    // Let's add a line so we can see the rotation
    line(0, 0, r, 0);
    popMatrix();
  }
  
  // Here's our function that adds the Player to the Box2D world
  public void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01f;
    fd.restitution = 0.3f;

    // Attach fixture to body
    body.createFixture(fd);
  }
  public void dir(){
    switch (key){
      case 'a': left = true; 
      break;
      case 'A': left = true; 
      break;
      case 'd': right = true; 
      break;
      case 'D': right = true; 
      break;
      case 'w': up = true; 
      break;
      case 'W': up = true; 
      break;
      case 's': down = true; 
      break;
      case 'S': down = true; 
      break;
    }
  }
  public void nodir(){
    switch (key){
      case 'a': left = false; 
      break;
      case 'A': left = false; 
      break;
      case 'd': right = false; 
      break;
      case 'D': right = false; 
      break;
      case 'w': up = false; 
      break;
      case 'W': up = false; 
      break;
      case 's': down = false; 
      break;
      case 'S': down = false; 
      break;
    }
  }
  public void move(){
    if(left ==true){
      applyForce(new Vec2(-50,0));
    }
    if(right ==true){
      applyForce(new Vec2(50,0));
    }
    if(up ==true){
      f=max(0,f-0.2f);
    }
    if(down ==true){
      f=max(0,f+0.2f);
    }
  }
 public void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }   
}
  
  
public void SpilSetup(){
  scroll = 0;
  speed=1;
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



public void startSetup(){
  clear();
  background(144,192,107);
  start.show();
  textAlign(CENTER);
  textSize(32);
  fill(0, 102, 153);
  text("SlingClimb",width/2,100);
}
public void Spil(){
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
  text("score:   "+PApplet.parseInt(score),20,30);
}

public void scroll(){
  while(p.y<400-scroll){
    scroll += speed;
    speed = speed*1.0001f;
    randomObs();
    score += speed*2;
  }
  scroll += speed;
  speed = speed * 1.0001f;
  score += speed;
}

public void update(){
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

public void randomObs(){
  float spawn = random(100);
  if(spawn<ObstacleFreq*speed){
    float sizeX =  random(Obstaclesize.x*2,Obstaclesize.y*2);
    float sizeY =  random(Obstaclesize.x,Obstaclesize.y);
    obstacles.add(new Obstacle(random(width),-50-scroll-sizeY,sizeX,sizeY));
  }
}
public void Start(){
  
}

public void StartButton(){
  if(start.click()){
    SpilSetup();
    gamestate=1;
  }
}
  public void settings() {  size(2000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Test" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
