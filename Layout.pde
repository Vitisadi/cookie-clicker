void layout() {
  textFont(adobeArabicRegular);
  textAlign(CENTER);
  textSize(45);
  fill(220);
  //background(65, 150, 160);
  image(backgroundStripes, 0, 0, width, height);
  image(cookieImage, 100, 300, 500, 500);
  
  strokeWeight(5);
  line(650,0, 650, height);
  line(width-700,0,width-700, height);
  line(width- 1350, 125, width-700, 125);
  
  int yPosition = 250;
  for (int i=0; i< 11; i++) {
    line(width - 700, i*125 - yPosition, width, i*125 - yPosition);
  }
  for(int i=0; i < items.length; i++){
    CookieBuilding item = items[i];
    if (item.cost <= numberCookies) {
      fill(244, 244, 144);
    } else {
        fill(220);
      }
    text("(" + item.productionRate + ") " + item.name + " (" + item.cost + ")", width-350, i*125 + yPosition - 20);
  }
  fill(255);
  textSize(45);
  if(numberCookies >= 1000000) {
    fill(255,0,0);
  } else {
      fill(255);
    }
  text("Repair Ship", width - 350, height - 110);
  text("1 MILLION COOKIES", width - 350, height - 35);
  fill(255);
  textSize(60);
  text("My towers:", 1000, 100);
  text("(Prod. Rate)-(Cost)", width-350, 100);
  text(numberCookies + " Cookies", 350, 150);
  textSize(50);
  text("per second: " + cookiesPerSecond, 350, 225);
}
