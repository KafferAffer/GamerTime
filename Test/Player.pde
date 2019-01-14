
class Player{
  
  //Player body
  Body body;
  float r;

  color col;
  
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
  void killBody() {
    box2d.destroyBody(body);
  }
  
  // Is the Player ready for deletion?
  boolean done() {
    // Let's find the screen position of the Player
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }
  // 
  void display() {
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
  void makeBody(float x, float y, float r) {
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
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);
  }
  void dir(){
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
  void nodir(){
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
  void move(){
    if(left ==true){
      applyForce(new Vec2(-300,0));
    }
    if(right ==true){
      applyForce(new Vec2(300,0));
    }
    if(up ==true){
      f=max(0,f-1);
      float lx=particles.get(0).x;
      float ly=particles.get(0).y+scroll;
      particles.get(0).killBody();
      particles.remove(0);
      particles.add(new Particle(lx,ly,4));
      Grab(particles.get(0).body,f*5);
    }
    if(down ==true){
      f=max(0,f+1);
      float lx=particles.get(0).x;
      float ly=particles.get(0).y+scroll;
      particles.get(0).killBody();
      particles.remove(0);
      particles.add(new Particle(lx,ly,4));
      Grab(particles.get(0).body,f*5);
    }
  }
 void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }   
}
  
  
