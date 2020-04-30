#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN D4
#define SS_PIN D3

MFRC522 mfrc522(SS_PIN, RST_PIN);
String tagUID1 = "79 E7 4E 1B";
String tagUID2 = "17 E4 1E 26";
String tagUID3 = "10 F4 8D 79";

String tagUID4 = "99 8E 29 01";
String tagUID5 = "39 B9 8D 79";
String tagUID6 = "45 E1 EC C3";

String tagUID7 = "C3 3F DE C3";
String tagUID8 = "8A 13 61 83";
String tagUID9 = "79 D6 46 1B";

String tagUID10 = "19 A2 4F 1B";
String tagUID11 = "2D BB B4 73";
String tagUID12 = "D4 08 30 83";
String tagOLD = "";

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  while (!Serial);

  SPI.begin();
  mfrc522.PCD_Init();

  Serial.println(F("Scan PICC..."));

}

void loop() {
  // put your main code here, to run repeatedly:
  delay(500);
  if (! mfrc522.PICC_IsNewCardPresent()) {
    Serial.println("Ikke en ny PICC");
  } else {
    if (! mfrc522.PICC_ReadCardSerial()) {
      Serial.println("Kan ikke laese UID");
      return;
    } else {
      String tag = "";
      for (byte i = 0; i < mfrc522.uid.size; i++) {
        tag.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
        tag.concat(String(mfrc522.uid.uidByte[i], HEX));
      }
      tag.toUpperCase();
      if (tag.substring(1) == tagUID1) {
        tagOLD = tag;
        Serial.println(F("1f1#01"));
      } else if (tag.substring(1) == tagUID2) {
        tagOLD = tag;
        Serial.println(F("1f2#02"));
      } else if (tag.substring(1) == tagUID3) {
        tagOLD = tag;
        Serial.println(F("a1c#03"));
        } else if (tag.substring(1) == tagUID4) {
        tagOLD = tag;
        Serial.println(F("2f1#04"));
      } else if (tag.substring(1) == tagUID5) {
        tagOLD = tag;
        Serial.println(F("2F2#05"));
        } else if (tag.substring(1) == tagUID6) {
        tagOLD = tag;
        Serial.println(F("a2C#06"));
      } else if (tag.substring(1) == tagUID7) {
        tagOLD = tag;
        Serial.println(F("3F1#07"));
        } else if (tag.substring(1) == tagUID8) {
        tagOLD = tag;
        Serial.println(F("3F2#08"));
      } else if (tag.substring(1) == tagUID9) {
        tagOLD = tag;
        Serial.println(F("a3C#09"));
        } else if (tag.substring(1) == tagUID10) {
        tagOLD = tag;
        Serial.println(F("4F1@10"));
      } else if (tag.substring(1) == tagUID11) {
        tagOLD = tag;
        Serial.println(F("4F2@11"));
        } else if (tag.substring(1) == tagUID12) {
        tagOLD = tag;
        Serial.println(F("a4C@12"));
      } else if (tagOLD.substring(1) != tag.substring(1)) {
        tagOLD = tag;
        Serial.println(F("Found Wrong Tag!"));
      }
    }
  }
}
