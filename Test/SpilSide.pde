void Spil(){
  clear();
  background(144,192,107);
  box2d.step();
  scroll();
  display();
}

void scroll(){
  scroll++;
}

void display(){
  for (Obstacle wall: obstacles) {
    wall.display();
  }
}
