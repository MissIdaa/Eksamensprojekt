class runde {                                                       //Klassen runder starter her
  int rno;                                                          //Rundenummer
  String otext;                                                     //Opgavetekst
  PImage picf1, picf2, picc;
  IntList order = new IntList();                                    //Liste over rækkefølge af billeder
  String point = "not";                                             //Point
  AudioPlayer filef1, filef2, filec, hvilket_ord, rigtigt, forkert;
  IntList player = new IntList();                                   //Liste over rækkefølge af lydfiler
  long previous = 0;
  long timestamp = 0;
  boolean[] showi = {false, false, false};
  boolean[] playi = {false, false, false};

  runde(int no, String opgavetext, PApplet p) {                     //Start på en runde, her loades tingene ligesom i setup
    previous = millis();
    minim = new Minim(p);
    rno = no;
    otext = opgavetext;
    picf1 = loadImage(str(rno)+"f1.png");
    picf2 = loadImage(str(rno)+"f2.png");
    picc = loadImage(str(rno)+"c.png");

    order.append(1);
    order.append(2);
    order.append(3);
    order.shuffle();                                               //Rækkefølgen blandes

    filef1 = minim.loadFile(str(rno)+"f1.mp3");
    filef2 = minim.loadFile(str(rno)+"f2.mp3");
    filec = minim.loadFile(str(rno)+"c.mp3");
    hvilket_ord = minim.loadFile("hvilket_ord.mp3");
    rigtigt = minim.loadFile("rigtigt.mp3");
    forkert = minim.loadFile("ov_igen.mp3");
  }
  /////////////////////
  // En enkelt runde //
  /////////////////////
  void render() {
    hvilket_ord.play();
    if (timestamp == 0) {                                    //Her starter runden
      timestamp = millis();                                  //Runden får en tid
    }
    for ( int j=0; j < 3; j++) {
      if (millis() > timestamp + 2000*(j+1) && !showi[j]) {  //Laver delay mellem hver "spawn" af billede og lyd
        showi[j] = true;                                     //Billedet gøres true
        playi[j] = true;                                     //Lydfilen ligeledes
      }
    }
    // Placering af billederne + afspilning af lyd til den pågældene runde //
    for (int i=0; i < order.size(); i++) {
      float posx = 165 + i*width/3;                          
      float posy = height/2;
      if (showi[i]) {
        if (order.get(i) == 1) {
          image(picf1, posx, posy);
          if (playi[i]) {
            filef1.play();
            playi[i] = false;
          }
        } else if (order.get(i) == 2) {
          image(picf2, posx, posy);
          if (playi[i]) {
            filef2.play();
            playi[i] = false;
          }
        } else if (order.get(i) == 3) {
          image(picc, posx, posy);
          if (playi[i]) {
            filec.play();
            playi[i] = false;
          }
        }
      }
    }
    // Boks som angiver, hvor man er på skærmen med musen //
    noStroke();
    fill(220, 220, 220, 100);
    if (mouseX < width/3) {
      rect(0, 0, width/3, height);
    } else if (mouseX < 2*width/3) {
      rect(width/3, 0, width/3, height);
    } else if (mouseX > 2*width/3) {
      rect(2*width/3, 0, width/3, height);
    }

    // Rigtig-/forkert-skærm //
    textSize(50);
    fill(0);
    if (point == "rigtigt") {
      text("RIGTIGT!", width/2, height/4);
      rigtigt.play();
    } else if (point == "forkert") {
      text("FORKERT!", width/2, height/4);
      forkert.play();
    } else {
      text(otext, width/2, height/4);
    }
  }

  // Musens position passende til billede //
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
