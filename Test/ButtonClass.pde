class Button {
  PVector pos;
  PVector size;
  String text;
  Button(PVector pos_, PVector size_, String text_){
    pos = pos_;
    size = size_;
    text = text_;
  }
  boolean click (){
    if(mouseX<pos.x+size.x/2||pos.x-size.x/2<mouseX||mouseY<pos.y+size.y/2||pos.y-size.y/2<mouseY){
      return true;
    }
    return false;
  }
  void show(){
    rectMode(CENTER);
    fill(200,200,200);
    rect(width/2,500,200,100);
    
    textAlign(CENTER);
    textSize(32);
    fill(0, 102, 153);
    text("Start",width/2,500);
  }
}
