void grapple(){
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
  
  color col;

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
    fd.friction = 0.3;
    fd.restitution = 0.5;
    
    body.createFixture(fd);

    col = color(175);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  
  // Is the particle ready for deletion?
  boolean done() {
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
  void display() {
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

void Grab(Body i,float dist){
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

void updatePoint(){
  if (particles.size()>0){pointed = true;}
  if(pointed){
    lx=particles.get(0).x;
    ly=particles.get(0).y;
    removePoint();
    particles.add(new Particle(lx,ly+scroll,4));
    if(f*5+0.1<dist(p.x,p.y,lx,ly)){
      Grab(particles.get(0).body,f*5);
    }
  }
  println(f*5);
  println(dist(p.x,p.y,lx,ly));
}

void removePoint(){
  for(int i = 0; i<particles.size();i++){
    particles.get(i).killBody();
    particles.remove(i);
    pointed = false;
  }
}
