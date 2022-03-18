import java.util.*; //<>//
import processing.sound.*;

class AcquiredBuilding {
  int x;
  int y;
  String image;
}

class CookieBuilding {

  CookieBuilding() {
  }

  CookieBuilding(String name, int productionRate, int cost, float costIncreasePercent, int amount) {
    this.name = name;
    this.productionRate = productionRate;
    this.cost = cost;
    this.costIncreasePercent = costIncreasePercent;
    this.amount = amount;
  }

  //public String serializeToString() {
  //  return name + "," + cost + "," + productionRate + "," + costIncreasePercent + "," + amount;
  //}

  public void loadFromString(String data) {
    String[] params = split(data, ",");

    name = params[0];
    productionRate = Integer.parseInt(params[1]);
    cost = Integer.parseInt(params[2]);
    costIncreasePercent = Float.parseFloat(params[3]);
    amount = Integer.parseInt(params[4]);
  }

  String name;
  int amount; //amount of building you have
  int productionRate; //amount of cookies being make per building 
  int cost; //cost of building
  float costIncreasePercent; //cost increase every building bought
}

PImage cookieImage;
PImage backgroundStripes;
PImage endScreenBG;
SoundFile cookieClickSF;
SoundFile titleScreenMusic;
SoundFile gameScreenMusic;
SoundFile endScreenMusic;
int numberCookies = 0;
int cookiesPerClick = 1;
int cookiesPerSecond = 0;
String optionBought;
int startTime;
int startTimeText;
int errorX = 0;
int errorY = 0;
int errorXSpeed = 25;
int errorYSpeed = 25;
PFont adobeArabicRegular;

int textX = 0;
int textY = 0;

String itemImagePNG; 
PImage itemImage;

boolean titleScreenShown = true;
boolean endScreenShown = false;
boolean changeColorRedWhite = false;
boolean changeColorGreenBlue = false;

String sos = "S\nO\nS";
String help = "H\nE\nL\nP";
String objective = "Your Objective\nCollect enough cookies to repair your ship.\nClick the cookie to gain cookies! \nThere is also a shop to create automated production! \nPress any key to begin\n(Dev cheat. Press Q for 1 million cookies)";
int textSpeed = 10;

CookieBuilding[] items = {
  new CookieBuilding("Clicker", 1, 50, 1.1, 0), //name, productionRate, cost, costIncreasePercent, amount
  new CookieBuilding("Grandma", 5, 250, 1.1, 0), 
  new CookieBuilding("Farm", 25, 1250, 1.1, 0), 
  new CookieBuilding("Plantation", 100, 5000, 1.1, 0), 
  new CookieBuilding("Mine", 500, 25000, 1.1, 0), 
  new CookieBuilding("Factory", 1000, 50000, 1.1, 0), 
  new CookieBuilding("Bank", 5000, 250000, 1.1, 0), 
};

List<AcquiredBuilding> acquiredBuildingList = new ArrayList<AcquiredBuilding>();

//void saveGame () {
//  List<String> settings = new ArrayList();
//  for (CookieBuilding cookieBuilding : items) {
//    settings.add(cookieBuilding.serializeToString());
//  }
//  saveStrings("cookieClicker.txt", settings.toArray(new String[0]));
//}

void titleScreen() {
  background(0);
  fill(255);
  textSize(100);
  if(!titleScreenMusic.isPlaying()) {
  titleScreenMusic.play();    
  }
  textAlign(LEFT);
  if (millis () - startTimeText >= 1000) {
    startTimeText = millis();
    changeColorRedWhite = !changeColorRedWhite;
    changeColorGreenBlue = !changeColorGreenBlue;
  }
  if (changeColorRedWhite) {
    fill(255,0,0);
  } else {
      fill(255);  
    }
  text("OH NO!!!", textX, 200);
  text("Your Space Ship is Malnfunctioning!!!", textX - 700, 350);
  if (textX > width + 600) {
    textX = -1500;
  }
  textLeading(100);
  textAlign(CENTER);
  if (changeColorGreenBlue) {
    fill(100, 200, 100);
  } else {
    fill(50,50,200);
  }
  text(sos, 250, textY);
  if (changeColorGreenBlue) {
    fill(50,50,200);
  } else {
    fill(100, 200, 100);
  }
  text(help, width - 250, textY - 50);
  
  fill(255,255, 100);
  textSize(50);
  text(objective, width/2, 450); 
  
  textX += 5;
  textY += textSpeed;
  
  if (textY > height) {
    textSpeed = -textSpeed;
  }
  
  if(textY < 0){
    textSpeed = -textSpeed;
  }
  
  fill (255,0,0);
  text ("ERROR", errorX, errorY);

  errorX += errorXSpeed;
  errorY += errorYSpeed;
  
  if(errorX > width || errorX < 0) {
    errorXSpeed = -errorXSpeed;
  }
  if(errorY > height || errorY < 0){
    errorYSpeed = -errorYSpeed;
  }
}

void endScreen() {
  image(endScreenBG, 0,0, width, height);  
  textSize(100);
  text("YOU DID IT!!!", width/2, height/2 + 400);
  if(!endScreenMusic.isPlaying()) {
    endScreenMusic.play();
  }
}
void setup() {
  size(2000, 1200);
  cookieImage = loadImage("cookie_PNG.png");
  backgroundStripes = loadImage("bgBlue.jpg");
  endScreenBG = loadImage("victoryBG.jpg");
  adobeArabicRegular = loadFont("AdobeArabic-Regular-48.vlw");
  cookieClickSF = new SoundFile(this, "click.mp3");
  titleScreenMusic = new SoundFile(this, "ComputerErrorSong.wav");
  gameScreenMusic = new SoundFile(this, "WiiTheme.wav");
  endScreenMusic = new SoundFile(this, "Champions.wav"); //<>//
  startTime = 1000;
}

void draw () {
  if (titleScreenShown) {
    titleScreen();
    gameScreenMusic.stop();
    return; 
  }  
  if (endScreenShown) {
    endScreen();
    gameScreenMusic.stop();
    return;
  }
  titleScreenMusic.stop();  
  endScreenMusic.stop();
  if(!gameScreenMusic.isPlaying()){
    gameScreenMusic.play();
  }
  layout();
  addValue();
  drawAcquiredBuildings();
}
void drawAcquiredBuildings() {
  for( AcquiredBuilding building : acquiredBuildingList) {
    PImage buildingImage = loadImage(building.image);
    image(buildingImage, building.x, building.y, 150, 150);
  }
}
void mousePressed () {
    if (titleScreenShown) {
      titleScreen();
      return; 
  }  
  if (endScreenShown) {
    endScreen();
    return;
  }
  if (dist(mouseX, mouseY, 350, 550) < 250 && mousePressed) {
    numberCookies += cookiesPerClick;
    cookieClickSF.play();
  }
  for (int i=0; i < items.length; i++) {
    if ((i -1)* 125 + 250 < mouseY && mouseY < i *125 + 250 && width - 700 < mouseX && mouseX < width) {
      CookieBuilding item = items[i];
      if (numberCookies >= item.cost) {
        AcquiredBuilding building = new AcquiredBuilding();
        building.x = int(random(650, 1150)); 
        building.y = int(random(225, height - 150));  
        building.image = item.name + ".png";
        acquiredBuildingList.add(building);
        item.amount++;
        cookiesPerSecond += item.productionRate;
        numberCookies -= item.cost;
        item.cost = round(item.cost * item.costIncreasePercent);
      }
    }
  }
  if(numberCookies >= 1000000 && mouseX < width && mouseX > width-700 && mouseY < height && mouseY > height - 200){
    numberCookies -= 1000000;
    endScreenShown = true;
  }
  //saveGame();
}
void addValue() {
  while (millis () - startTime >= 1000) {
    numberCookies += cookiesPerSecond;
    startTime = millis();
  }
}

void keyPressed () {
  if (titleScreenShown){
    titleScreenShown = false;
  }
  if (keyCode == 81){
    numberCookies += 1000000;
  }
}
