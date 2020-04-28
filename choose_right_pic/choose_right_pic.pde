PImage startbg;
PImage spilbg;
ArrayList<runde> runder;
int currRound;
int cd = 180;
Boolean Spil1 = false;
Boolean Spil2 = false;
Boolean Start = true; 
int score = 0;
boolean point = false;

void setup() {
  fullScreen();
  runder = new ArrayList<runde>();
  runder.add(new runde(1, "Hvilket ord lyder anderledes?"));
  runder.add(new runde(2, "Hvilket ord lyder anderledes?"));
  runder.add(new runde(3, "Hvilket ord lyder anderledes?"));
  runder.add(new runde(4, "Hvilket ord lyder anderledes?"));
  currRound = round(random(1, 2));
  startbg = loadImage ("Startbaggrund.png");
  spilbg = loadImage ("Spilbaggrund.png");
}

void draw() {
  if (Spil1) {
    background(spilbg);
    fill(0);
    text(score, width/2-100, 20); // Display af score // Den tæller opad så længe der står rigtigt
    text("ud af 4", width/2+20, 20);
    if (cd == 0) {            
      currRound = currRound % runder.size() + 1;
      cd = 180;
    }
    println(currRound);
    for (runde r : runder) {
      if (r.rno == currRound) {
        r.render();
        if (r.point) {
          cd -= 1;
        }
      }
    }
  }
  if (Spil2) {
    background(spilbg);
    text("Spil 2", 800, 200);
  }
  if (Start) {
    background(startbg);
    fill(255);
    textMode(CENTER);
    textSize(48);
    text("Hej med dig, hvilket spil vil du gerne spille?", 450, 200);
    textSize(36);
    text("Venstre piletast for spil 1, højre for spil 2", 570, 275);
    fill(255);
    textSize(80);
    text("Spil 1", 530, 610);
    text("Spil 2", 1180, 610);
  }
}

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
