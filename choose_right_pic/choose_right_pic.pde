// Billeder
PImage startbg;
PImage spilbg;
// Lyd
import ddf.minim.*;
Minim minim;
AudioPlayer start_hej;

ArrayList<runde> runder;
int currRound;
int cd = 180;
Boolean Spil1 = false;
Boolean Spil2 = false;
Boolean Start = true; 
Boolean Spil1Slut = false;
int score = 0;
boolean point = false;
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
  currRound = round(random(1, 2));
  startbg = loadImage ("Startbaggrund.png");
  spilbg = loadImage ("Spilbaggrund.png");
  start_hej = minim.loadFile("start_hej.mp3");
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
    text(score, width/2-100, 20); // Display af score // Den tæller opad så længe der står rigtigt
    text("ud af 4", width/2+20, 20);
    if (cd == 0) {            
      currRound = currRound % runder.size() + 1;
      cd = 180;
    }
    //println(currRound);
    for (runde r : runder) {
      if (r.rno == currRound) {
        r.render();
        RFID();
        if (r.point) {
          cd -= 1;
        }
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
    text("Spil 1", width/4+50, 610);
    text("Spil 2", width/4 + width/2 -50, 610);
  }
  if (Spil1Slut) {
    background(startbg);
    textSize(72);
    fill(255);
    text("Du fik 4 ud af 4 rigtige! Godt klaret",width/2,height/2);
}
    if (score == 4) {
    delay(2000);
    Spil1 = false;
    Spil1Slut = true;
    }
}
// Piletaster på startskærmen og mellemrum
void keyPressed() {
  if (Start) {
    if (keyCode==LEFT) {
      Spil1 = true;
      Start = false;
    }
  }
  if (Start) {
    if (keyCode==RIGHT) {
      Spil2 = true;
      Start = false;
    }
  }
  if (keyCode==' ') {
    Spil1 = false; 
    Spil2 = false;
    Start = true;
  }
}

// Valg af svar
void mouseClicked() {
  for (runde r : runder) {
    if (r.rno == currRound) {
      if (r.hoverChoice() == 3) {
        r.point = true;
        score++;
      }
    }
  }
}

void RFID() {
  for ( runde r : runder) {
    if (r.chipCheck() == 3) {
      r.point = true;
      score++;
      r.point = false;
    }
  }
}
