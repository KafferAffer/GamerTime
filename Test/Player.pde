
class Player{
  
  //Player body
  Body body;
  float r;

  color col;
  
  boolean left = false;
  boolean right = false;


  Player(float x, float y, float r_) {
    r = r_;
    // This function puts the Player in the Box2d world
    makeBody(x, y, r);
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
    pushMatrix();
    translate(pos.x, pos.y+scroll);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, r*2, r*2);
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
    }
  }
  void move(){
    if(left ==true){
      applyForce(new Vec2(-300,0));
    }
    if(right ==true){
      applyForce(new Vec2(300,0));
    }
  }
 void applyForce(Vec2 force) {
   println("LOL");
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }   
}
  
  
