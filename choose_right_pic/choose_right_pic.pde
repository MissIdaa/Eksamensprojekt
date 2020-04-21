
PImage startbg;
PImage spilbg;
ArrayList<runde> runder;
int currRound;
int cd = 180;

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
  if (cd == 0) {            
    currRound = currRound % runder.size() + 1;
    cd = 180;
  }
  background(spilbg);
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

void mouseClicked() {
  for (runde r : runder) {
    if (r.rno == currRound) {
      if (r.hoverChoice() == 3) {
        r.point = true;
      }
    }
  }
}
