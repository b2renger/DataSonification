// this class holds all the data from the xml file
class Point {
  //int index;
  float videoTime;
  float att, med, raw, delta, theta;
  float lowa, higha, lowb, highb, lowg, highg;

  Point (float videoTime0, float att0, float med0, float raw0, float delta0, float theta0, float lowa0, float higha0, float lowb0, float highb0, float lowg0, float highg0) {
    //index =index0;
    videoTime = videoTime0;
    att=att0;
    med = med0;
    raw = raw0;
    delta = delta0;
    theta = theta0;
    lowa = lowa0;
    higha = higha0;
    lowb= lowb0;
    highb=highb0;
    lowg = lowg0;
    highg = highg0;
  }
}






