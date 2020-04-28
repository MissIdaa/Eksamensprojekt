class runde {
  int rno;
  String otext;
  PImage picf1, picf2, picc;
  IntList order = new IntList();
  boolean point = false;


  runde(int no, String opgavetext) {
    rno = no;
    otext = opgavetext;
    picf1 = loadImage(str(rno)+"f1.png");
    picf2 = loadImage(str(rno)+"f2.png");
    picc = loadImage(str(rno)+"c.png");
    order.append(1);
    order.append(2);
    order.append(3);
    order.shuffle();
  }

  void render() {
    for (int i=0; i<order.size(); i++) {
      float posx = 165 + i*width/3;
      float posy = height/2;
      if (order.get(i) == 1) {
        image(picf1, posx, posy);
      } else if (order.get(i) == 2) {
        image(picf2, posx, posy);
      } else if (order.get(i) == 3) {
        image(picc, posx, posy);
      }
    }
    noStroke();
    fill(220, 220, 220, 100);
    if (mouseX < width/3) {
      rect(0, 0, width/3, height);
    } else if (mouseX < 2*width/3) {
      rect(width/3, 0, width/3, height);
    } else if (mouseX > 2*width/3) {
      rect(2*width/3, 0, width/3, height);
    }

    textAlign(CENTER, CENTER);
    textSize(50);
    fill(0);
    if (point==true) {
      text("RIGTIGT!", width/2, height/4);
    } else {
      text(otext, width/2, height/4);
    }
  }
    

  int hoverChoice() {
    int returnno = 1000;
    if (mouseX < width/3) {
      returnno = order.get(0);
    } else if (mouseX < 2*width/3) {
      returnno = order.get(1);
    } else {
      returnno = order.get(2);
    }
    return returnno;
  }
}
