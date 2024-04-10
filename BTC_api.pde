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
float sellCount;
float buyCount;
color blanco = #FFFFFF;
color azul = #0066FD;
color verde = #66FE00;
color rojo = #FE0066;
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
  size(540, 260);
  background(50);  
  noStroke();
  smooth();
  secondsStart = second();
  secondsToRefresh = 10; // time to refresh data
  btc = 0.0;
  prevUpholdBTC = 0;
  prevCoinDeskBTC = 0;
  //bitcoinLogo = loadImage("./data/bitcoin_logo.png");
  instagramLogo = loadImage("./data/instagram_logo.png");  
  xDisplay = 12;
  yDisplay = 20;
  labelSize = 20;
  priceSize = 27;
  chartURL = "https://s2.coinmarketcap.com/generated/sparklines/web/7d/usd/1.png";
  arco = map(secondsToRefresh, 0, 10, 0, 2*PI);
  colorBtc = #000000;
  refresh = true;
}


void draw() {
    noStroke();
    fill(colorBtc);
    arco = map(secondsInterval, 0, 10, 0, 2*PI); 
    arc(xDisplay + 150, yDisplay + 80, 15, 15, 0, arco);
    if(arco == 2*PI) {
        stroke(colorBackground);
        fill(colorBackground);
        arc(xDisplay + 150, yDisplay + 80, 15, 15, 0, 2*PI);
    }
    // Load image from a web server
    webImg = loadImage(chartURL, "png");

    if(refresh == true){
      background(colorBackground);
      //logo Bitcoin
      //image(bitcoinLogo, xDisplay + 38, yDisplay - 70, 20, 20);
      secondsStart = second();
      
      //CoinDesk Price
      getCoinDeskAPI();
      textSize(labelSize);
      fill(254, 254, 254);
      textAlign(LEFT);  
      text("BTC CoinDesk", xDisplay, yDisplay);
      fill(colorBtc);
      textSize(priceSize);    
      textAlign(LEFT);
      text(nfc(btc, 2), xDisplay - 2, yDisplay + 30);
      //println(btc);
      
      //Coinmarket Chart
      textSize(labelSize);
      fill(254, 254, 254);
      textAlign(LEFT);  
      text("Coinmarketcap Chart", width/2 - xDisplay, yDisplay);
      image(webImg, width/2, yDisplay + 5);
      
      //Instagram Logo
      image(instagramLogo, width/2, yDisplay + 120, 40, 40);
      textAlign(LEFT);  
      text("@criptorusso", width/2 + 50, yDisplay + 145);
      image(webImg, width/2, yDisplay + 5);
  
      //Uphold Price
      getUpholdAPI();
      textSize(labelSize);
      fill(254, 254, 254);
      textAlign(LEFT);  
      text("BTC Uphold", xDisplay, yDisplay + 60);
      fill(colorBtc);
      textSize(priceSize);  
      textAlign(LEFT);
      text(nfc(btc, 2), xDisplay - 2, yDisplay + 90);
      //println(btc);*/
      
      //Localbitcoin Info
      //getLocalbitcoinAPI();
      //textSize(labelSize);
      //fill(254, 254, 254);
      //textAlign(LEFT);  
      //text("Localbitcoin", xDisplay, yDisplay + 120);
      //fill(blanco);
      //textSize(priceSize/2);  
      //textAlign(LEFT);
      //text("Ofertas de compra: " + nfc(sellCount, 0), xDisplay, yDisplay + 140);
      //text("Ofertas de venta: " + nfc(buyCount, 0), xDisplay, yDisplay + 160);      
    }
    refresh = timeToRefreshApi(secondsStart);
  }


void getCoinDeskAPI (){
  json = loadJSONObject("https://api.coindesk.com/v1/bpi/currentprice.json");
  bpiJson = (json.getJSONObject("bpi"));  
  btc = (bpiJson.getJSONObject("USD").getFloat("rate_float"));
  println("CoinDesk: " + prevCoinDeskBTC + " " + btc);
  setColorBTC(prevCoinDeskBTC, btc);
  prevCoinDeskBTC = btc;  
}


void getUpholdAPI (){
  json = loadJSONObject("https://api.uphold.com/v0/ticker/BTCUSD");
  btc = (json.getFloat("bid"));
  println("Uphold: " + prevUpholdBTC + " " + btc);
  setColorBTC(prevUpholdBTC, btc);
  prevUpholdBTC = btc;  
}

void getLocalbitcoinAPI(){
  json = loadJSONObject("https://localbitcoins.com/es/vender-bitcoins-online/ve/venezuela/transferencias-con-un-banco-especifico/.json");
  sellCount = json.getJSONObject("data").getFloat("ad_count");
  //println(json.getJSONObject("data").getInt("ad_list"));

  json = loadJSONObject("https://localbitcoins.com/es/comprar-bitcoins-online/ve/venezuela/transferencias-con-un-banco-especifico/.json");
  buyCount = json.getJSONObject("data").getFloat("ad_count");

}

void setColorBTC(float prevBTC, float currentBTC) {
  if (currentBTC < prevBTC){
    colorBtc = rojo;
  } else if (currentBTC > prevBTC) {
    colorBtc = verde;
  } else {  colorBtc = azul;}
}


boolean timeToRefreshApi(int secS){
  int secondsNow = second();
  secondsInterval = secondsNow - secS;
  if (secondsNow <= secS) {
    secondsInterval = 60 - secS + secondsNow;
  }
  //println(secS, secondsNow, secondsInterval);
  if ((secondsInterval >= secondsToRefresh) || (secondsInterval == 0)){
    //fill(colorBtc);
    //circle(xDisplay + 150, yDisplay + 80, 1.5 * secondsInterval);
    return true;
  }
  //fill(colorBtc);
  //circle(xDisplay + 150, yDisplay + 80, 1.5 * secondsInterval);
  return false;
}
