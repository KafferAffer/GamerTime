int gamestate = 0;

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

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
