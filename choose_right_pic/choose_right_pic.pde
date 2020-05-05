// Billeder
PImage startbg, spilbg, intro, help;
// Lyd
import ddf.minim.*;
Minim minim;
AudioPlayer start_hej, helps, intros, tilbage;

ArrayList<runde> runder;
int currRound;
int cd = 180;
Boolean Spil1 = false;
Boolean Spil2 = false;
Boolean Start = true; 
Boolean Intro1 = false;
Boolean Help1 = false;
Boolean Spil1Slut = false;
int score = 0;
// Arduino
import processing.serial.*;
Serial myPort;
String dataWemos = "Intet endnu";
String kortNum = "Intet endnu";
int kortNumTid = 0;

// Her startes programmet!
void setup() {
  fullScreen(P2D);
  textAlign(CENTER, CENTER);
  String portName = Serial.list() [0];
  //println("Proever: " + portName);
  // Arduino
  myPort = new Serial(this, portName, 115200);
  minim = new Minim(this);
  //Runderne
  runder = new ArrayList<runde>();
  runder.add(new runde(1, "Hvad lyder anderledes?", this));
  runder.add(new runde(2, "Hvad lyder anderledes?", this));
  runder.add(new runde(3, "Hvad lyder anderledes?", this));
  runder.add(new runde(4, "Hvad lyder anderledes?", this));
  currRound = int(random(4))+1;
  startbg = loadImage ("Startbaggrund.png");
  spilbg = loadImage ("Spilbaggrund.png");
  intro = loadImage ("intro.png");
  help = loadImage ("help.png");
  start_hej = minim.loadFile("start_hej.mp3");
  helps = minim.loadFile("help.mp3");
  intros = minim.loadFile("intro.mp3");
  tilbage = minim.loadFile("tilbage.mp3");
}

void draw() {
  // Arduino
  if (myPort.available() > 0) {
    dataWemos = myPort.readStringUntil ('\n');
    println("Received: " + dataWemos);
    if (dataWemos != null) {
      if (dataWemos.charAt(3) == '#') {
        kortNum = dataWemos.substring(5, dataWemos.length()-2);
        kortNumTid = (millis()+10);
      } else if (dataWemos.charAt(3) == '@') {
        kortNum = dataWemos.substring(4, dataWemos.length()-2);
        kortNumTid = (millis()+10);
      }
    }
  }

  //  println(kortNumTid + " : " + (millis()+10));
  if (kortNumTid < millis() && int(kortNum) != 0) {
    kortNum = "Time Out!";
    kortNumTid = 0;
  }
  println(kortNum); 
  // Spil 1
  if (Spil1) {
    background(spilbg);
    fill(0);
    text(score, width/2-100, 20); // Display af score
    text("ud af 4", width/2+20, 20);
    if (cd == 0) {            
      boolean choosing = true;
      int testRound = 1000;
      while (choosing) {
        testRound = int(random(4))+1;
        for (runde r : runder) {
          if (r.rno == testRound && r.point == "not") {
            choosing = false;
          }
        }
      }
      currRound = testRound;
      cd = 180;
    }
    //println(currRound);
    for (runde r : runder) {
      if (r.rno == currRound) {
        r.render();
        if (r.point == "rigtigt" || r.point == "forkert") {
          cd -= 1;
        }
        RFID();
      }
    }
  }
  // Spil 2
  if (Spil2) {
    background(spilbg);
    text("Spil 2", 800, 200);
  }
  // Startskærm
  if (Start) {
    background(startbg);
    fill(255);
    start_hej.play();
    textSize(48);
    text("Hej med dig, hvilket spil vil du gerne spille?", width/2, 200);
    textSize(36);
    text("Venstre piletast for spil 1, højre for spil 2", width/2, 275);
    fill(255);
    textSize(80);
    text("Spil 1", width/4+250, 450);
    text("Spil 2", width/4 + width/2 -250, 450);
  }
  if (Spil1Slut) {
    background(startbg);
    textSize(72);
    fill(255);
    text("Du fik "+str(score)+" ud af 4 rigtige! Godt klaret", width/2, height/2-250);
  }
  boolean slut = true;
  for (runde r : runder) {
    if (r.point == "not") {
      slut = false;
    }
  }
  if (slut) {
    delay(2000);
    Spil1 = false;
    Spil1Slut = true;
  }
  if (Help1) {
    background(help);
    helps.play();
  }
  if (Intro1) {
    background(intro);
    intros.play();
  }
}
// Piletaster på startskærmen og mellemrum
void keyPressed() {
  if (Start) {
    if (keyCode==LEFT) {
      Intro1 = true;
      Start = false;
      Spil1 = false;
    }
  }
  if (Start) {
    if (keyCode==RIGHT) {
      Spil2 = true;
      Start = false;
    }
  }
  if (Spil1) {
    if (keyCode==' ') {
      Spil1 = false; 
      Spil2 = false;
      Start = true;
    }
  }
  if (Intro1) {
    if (keyCode==DOWN) {
      Intro1 = false;
      Help1 = true;
    }
  }
  if (Intro1) {
    if (keyCode==UP) {
      Intro1 = false;
      Spil1 = true;
    }
  } 
  if (Help1) {
    if (keyCode==' ') {
      Intro1 = true;
      Help1 = false;
    }
  }
}

// Valg af svar
void mouseClicked() {
  for (runde r : runder) {
    if (r.rno == currRound) {
      if (r.hoverChoice() == 3) {
        r.point = "rigtigt";
        score++;
      }
      if (r.hoverChoice() != 3) {
        r.point = "forkert";
      }
    }
  }
}

void RFID() {
  for ( runde r : runder) {
    if (r.rno == currRound) {
      println(int(kortNum));
      if ((currRound == 1 && int(kortNum)==3) || (currRound == 2 && int(kortNum)==6) || (currRound == 3 && int(kortNum)==9) || (currRound == 4 && int(kortNum)==12)) {
        r.point = "rigtigt";
        score ++;
      } else if (int(kortNum) != 0) {
        r.point = "forkert";
      }
    }
  }
}
