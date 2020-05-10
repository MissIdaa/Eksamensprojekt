// Billeder
PImage startbg, spilbg, intro, help;                       //Billederne navngives
// Lyd //
import ddf.minim.*;                                        //Import af det library vi bruger til lyd
Minim minim;
AudioPlayer start_hej, helps, intros, tilbage;             //Lydfilerne navngives

ArrayList<runde> runder;                                   //Oprettelse af en arrayliste for runderne
int currRound;                                             //Variable for current round
int cd = 180;                                              //Cool down på 180
Boolean Spil1 = false;                                     //Hvis true vises spilskærmen for spil 1
Boolean Spil2 = false;                                     //Hvis true vises spilskærmen for spil 2
Boolean Start = true;                                      //Hvis true vises startskærmen
Boolean Intro1 = false;                                    //Hvis true vises introskærmen
Boolean Help1 = false;                                     //Hvis true vises hjælpeskærmen
Boolean Spil1Slut = false;                                 //Hvis true vises slutskærmen
int score = 0;                                             //Vores score, som starter på 0

// Arduino //
import processing.serial.*;                                //Import af library til vores arduino
Serial myPort;                                             //Opretter objekt fra serial-class
String dataWemos = "Intet endnu";                          //Tekst som printes hvis der endnu ikke er modtaget noget
String kortNum = "Intet endnu";                            //--||--
int kortNumTid = 0;                                        //Tiden starter på 0

//////////////////
// Programstart //
//////////////////
void setup() {
  fullScreen(P2D);                                         //Canvasstørrelse og to-dimentions render
  textAlign(CENTER, CENTER);                               //Tekstplacering
  
  // Arduino opsætning af serial port //
  String portName = Serial.list() [0]; 
  myPort = new Serial(this, portName, 115200);
  minim = new Minim(this);
  
  //Runderne//
  runder = new ArrayList<runde>();                         //Arrayliste
  runder.add(new runde(1, "Hvad lyder anderledes?", this));//Ny runde + nummer
  runder.add(new runde(2, "Hvad lyder anderledes?", this));//--||--
  runder.add(new runde(3, "Hvad lyder anderledes?", this));
  runder.add(new runde(4, "Hvad lyder anderledes?", this));
  
  currRound = int(random(4))+1; //Tilfældig startrunde
  
  // Loader filer //
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
  // Arduino igen //
  // Læser navngivningen af chippene //
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
  
  // Sørger for chippen ikke læses igen og igen //
  if (kortNumTid < millis() && int(kortNum) != 0) {
    kortNum = "Time Out!";
    kortNumTid = 0;
  }
  ////////////
  // Spil 1 //
  ////////////
  if (Spil1) {
    background(spilbg);                                  //Baggrundsbillede
    fill(0);                                             //Tekstfarve
    text(score, width/2-100, 20);                        //Display af score
    text("ud af 4", width/2+20, 20);                     //Fortsat
    if (cd == 0) {                                       //If statement for cooldown, vælger en runde vi ikke har kørt
      boolean choosing = true;
      int testRound = 1000;                              //Bare et urealistisk højt antal
      while (choosing) {                                 //While-løkke, da vi ikke ved hvor mange gennemløb der bliver
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

    for (runde r : runder) {                              //Får spillet til at gå videre til næste runde ved at køre render
      if (r.rno == currRound) {
        r.render();
        if (r.point == "rigtigt" || r.point == "forkert") {
          cd -= 1;
        }
        RFID();                                           //Kører vores RFID - chipcheck
      }
    }
  }
  // Spil 2 (Bruges ikke) //
  if (Spil2) {
    background(spilbg);
    text("Spil 2", 800, 200);
  }
  ////////////////
  // Startskærm //
  ////////////////
  // Designet //
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
  // Slut-layout //
  if (Spil1Slut) {
    background(startbg);
    textSize(72);
    fill(255);
    text("Du fik "+str(score)+" ud af 4 rigtige! Godt klaret", width/2, height/2-250);
  }
  // Går til slutskærm, når der ikke er flere runde //
  boolean slut = true;
  for (runde r : runder) {
    if (r.point == "not") {
      slut = false;
    }
  }
  // If statements til at afspille de enkelte skærme //
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
// Regler for piletaster på startskærmene og mellemrum //
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

// Valg af svar med musen //
void mouseClicked() {
  for (runde r : runder) {
    if (r.rno == currRound) {                             //Checker runden
      if (r.hoverChoice() == 3) {                         //Hvis det er 3, gives point
        r.point = "rigtigt";
        score++;                                          //Score lægges til
      }
      if (r.hoverChoice() != 3) {                         //Hvis ikke 3, gives ikke point
        r.point = "forkert";
      }
    }
  }
}

////////////////////////////
// Valg af svar med CHIP //
//////////////////////////
// Smme princip som med musen, dog checker vi om den nuværende runde passer med nummeret og chippen i linje 229 //
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
