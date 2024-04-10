/**
 * Functions. 
 * API CoinDesk, to get Bitcoin price
 */

JSONObject json;
JSONObject bpiJson;
PImage webImg;
//PImage bitcoinLogo;
PImage instagramLogo;
int secondsStart;
int secondsToRefresh;
int secondsInterval;
float btc;
float prevUpholdBTC;
float prevCoinDeskBTC;
float prevLocalbitcoinsBTC;
float sellCount;
float buyCount;
color blanco = #FFFFFF;
color azul = #0066FD;
color verde = #66FE00;
color rojo = #FE0066;
color amarillo = #F1FA08;
color amarillo2 = #FACD17;
color colorBtc;
int colorBackground = 50;
int xDisplay;
int yDisplay;
int labelSize;
int priceSize;
String chartURL;
float arco;
boolean refresh;


void setup() {
  frameRate(4); 
  size(450, 180);
  background(50);  
  noStroke();
  smooth();
  secondsStart = second();
  secondsToRefresh = 10; // tiempo para refresacr los valores
  btc = 0.0;
  prevUpholdBTC = 0;
  prevCoinDeskBTC = 0;
  prevLocalbitcoinsBTC = 0;
  //bitcoinLogo = loadImage("./data/bitcoin_logo.png");
  instagramLogo = loadImage("./data/instagram_logo.png");  
  xDisplay = 12;
  yDisplay = 20;
  labelSize = 20;
  priceSize = 27;
  //chartURL = "https://s2.coinmarketcap.com/generated/sparklines/web/7d/usd/1.png";
  arco = map(secondsToRefresh, 0, 10, 0, 2*PI);
  colorBtc = #000000;
  refresh = true;
}


void draw() {
    noStroke();
    fill(amarillo2);
    arco = map(secondsInterval, 0, 10, 0, 2*PI); 
    arc(xDisplay + 280, yDisplay + 60, 40, 40, 0, arco);
    if(refresh == true){
        background(colorBackground);
        //image(bitcoinLogo, xDisplay + 38, yDisplay - 70, 20, 20); //logo Bitcoin
        secondsStart = second();
        getCoinDeskAPI(); //CoinDesk Price
        getUpholdAPI();  //Uphold Price
        //coinMarketChart();  //Coinmarket Chart
        instagramLogo(); //Instagram Logo
        getLocalbitcoinAPI();
    }
    refresh = timeToRefreshApi(secondsStart);
  }




///////////////////////////////////////////////////////////////////////
////////////////////////////// FUNCIONES //////////////////////////////
///////////////////////////////////////////////////////////////////////
void getCoinDeskAPI (){
  json = loadJSONObject("https://api.coindesk.com/v1/bpi/currentprice.json");
  bpiJson = (json.getJSONObject("bpi"));  
  btc = (bpiJson.getJSONObject("USD").getFloat("rate_float"));
  println("CoinDesk: prev " + prevCoinDeskBTC + " now " + btc);
  setColorBTC(prevCoinDeskBTC, btc);
  textSize(labelSize);
  fill(254, 254, 254);
  textAlign(LEFT);  
  text("BTC CoinDesk", xDisplay, yDisplay);
  fill(colorBtc);
  textSize(priceSize);    
  textAlign(LEFT);
  text(nfc(btc, 2), xDisplay - 2, yDisplay + 30);
  textSize(priceSize/2);    
  textAlign(LEFT);
  fill(amarillo2);
  text(nfc(prevCoinDeskBTC, 2), xDisplay + 140, yDisplay + 30);
  prevCoinDeskBTC = btc;  
}


void getUpholdAPI(){
  json = loadJSONObject("https://api.uphold.com/v0/ticker/BTCUSD");
  btc = (json.getFloat("bid"));
  println("Uphold: prev " + prevUpholdBTC + " now " + btc);
  setColorBTC(prevUpholdBTC, btc);
  textSize(labelSize);
  fill(254, 254, 254);
  textAlign(LEFT);  
  text("BTC Uphold", xDisplay, yDisplay + 60);
  fill(colorBtc);
  textSize(priceSize);  
  textAlign(LEFT);
  text(nfc(btc, 2), xDisplay - 2, yDisplay + 90);
  textSize(priceSize/2);    
  textAlign(LEFT);
  fill(amarillo2);  
  text(nfc(prevUpholdBTC, 2), xDisplay + 140, yDisplay + 90);
  prevUpholdBTC = btc;  
}

void getLocalbitcoinAPI(){
  //json = loadJSONObject("https://localbitcoins.com/es/vender-bitcoins-online/ve/venezuela/transferencias-con-un-banco-especifico/.json");
  json = loadJSONObject("https://localbitcoins.com/api/equation/btc_in_usd*1");
  btc = (json.getFloat("data"));
  println("Localbitcoins: prev " + prevLocalbitcoinsBTC + " now " + btc);
  setColorBTC(prevLocalbitcoinsBTC, btc);
  textSize(labelSize);
  fill(254, 254, 254);
  textAlign(LEFT);  
  text("BTC Localbitcoins", xDisplay, yDisplay + 120);
  fill(colorBtc);
  textSize(priceSize);    
  textAlign(LEFT);
  text(nfc(btc, 2), xDisplay - 2, yDisplay + 150);
  textSize(priceSize/2);    
  textAlign(LEFT);
  fill(amarillo2);  
  text(nfc(prevLocalbitcoinsBTC, 2), xDisplay + 140, yDisplay + 150);
  prevLocalbitcoinsBTC = btc;  
}

void setColorBTC(float prevBTC, float currentBTC) {
  if (currentBTC < prevBTC){
    colorBtc = rojo;
  } else if (currentBTC > prevBTC) {
    colorBtc = verde;
  } else {  colorBtc = azul;}
}

void coinMarketChart(){
    // Load image from a web server
    webImg = loadImage(chartURL, "png");
    textSize(labelSize);
    fill(254, 254, 254);
    textAlign(LEFT);  
    text("Coinmarketcap Chart", width/2 - xDisplay, yDisplay);
    image(webImg, width/2, yDisplay + 5);  
}

void instagramLogo(){
    image(instagramLogo, 50 + width/2, yDisplay + 40 + 80, 30, 30);
    textAlign(LEFT); 
    textSize(labelSize - 5);    
    text("@criptorusso", 50 + width/2 + 35, yDisplay + 40 + 100);
}

boolean timeToRefreshApi(int secS){
  int secondsNow = second();
  secondsInterval = secondsNow - secS;
  if (secondsNow <= secS) {
    secondsInterval = 60 - secS + secondsNow;
  }
  //println(secS, secondsNow, secondsInterval);
  if ((secondsInterval > secondsToRefresh) || (secondsInterval == 0)){
    //fill(colorBtc);
    //circle(xDisplay + 150, yDisplay + 80, 1.5 * secondsInterval);
    return true;
  }
  //fill(colorBtc);
  //circle(xDisplay + 150, yDisplay + 80, 1.5 * secondsInterval);
  return false;
}
