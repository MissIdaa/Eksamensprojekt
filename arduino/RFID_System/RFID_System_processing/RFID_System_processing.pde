import processing.serial.*;

Serial myPort;
String dataWemos = "Intet endnu";
String kortNum = "Intet endnu";
int kortNumTid = 0;
PImage hus, mus, fisk;

void setup() {
  fullScreen();
  String portName = Serial.list() [0];
  println("Proever: " + portName);
  myPort = new Serial(this, portName, 115200);
  hus = loadImage("1f1.png");
  mus = loadImage("1f2.png");
  fisk = loadImage("1c.png");

  textSize(32);
  fill(0, 102, 153);
}

void draw() {
 if (myPort.available() > 0) {
    dataWemos = myPort.readStringUntil ('\n');
    println("Received: " + dataWemos);
    if (dataWemos != null) {
      if (dataWemos.charAt(3) == '#') {
        kortNum = dataWemos.substring(5, dataWemos.length()-2);
        kortNumTid = (millis()+5000);
      } else if (dataWemos.charAt(3) == '@') {
        kortNum = dataWemos.substring(4, dataWemos.length()-2);
        kortNumTid = (millis()+5000);
      } 
    }
  }

//  println(kortNumTid + " : " + (millis()+5000));
  if (kortNumTid < millis() && int(kortNum) != 0) {
    kortNum = "Time Out!";
    kortNumTid = 0;
  }
  background(254);
  println(kortNum.length());
  text("Fundet kort som tekst" + kortNum, 10, 30);
  text("Fundet kort som int"  + int(kortNum), 10, 60);

  if (int(kortNum) == 1) {
    image(hus, 200, 200);
  }

  if (int(kortNum) == 2) {
    image(mus, 500, 200);
  }
  if (int(kortNum) == 3) {
    image(fisk, 800, 200);
  }


  if (mousePressed == true) {
    myPort.write('1');
    text("Mouse pressed!!!!", 10, 210);
    print("MP ");
  } else {
    myPort.write('0');
    text("Mouse NOT pressed", 10, 210);
  }
}
