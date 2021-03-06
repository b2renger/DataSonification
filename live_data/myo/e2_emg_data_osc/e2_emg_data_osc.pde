import de.voidplus.myo.*;


import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Myo myo;
ArrayList<ArrayList<Integer>> sensors;

void setup() {
  size(800, 400);
  background(255);
  noFill();
  stroke(0);
  // ...
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 9876);

  myo = new Myo(this);
  // myo.setVerbose(true);
  // myo.setVerboseLevel(4); // Default: 1 (1-4)

  myo.withEmg();
  // myo.withoutEmg();

  sensors = new ArrayList<ArrayList<Integer>>();
  for (int i=0; i<8; i++) {
    sensors.add(new ArrayList<Integer>());
  }
}

void draw() {
  background(255);
  // ...

  synchronized (this) {
    OscMessage myMessage = new OscMessage("/test");
    for (int i=0; i<8; i++) {
      if (!sensors.get(i).isEmpty()) {
        beginShape();
        myMessage.add(sensors.get(i).get(0)); /* add an int to the osc message */
        for (int j=0; j<sensors.get (i).size(); j++) {
          vertex(j, sensors.get(i).get(j)+(i*50));
        }
        endShape();
      }
    }
   oscP5.send(myMessage, myRemoteLocation);
  }
}

// ----------------------------------------------------------

void myoOnEmg(Myo myo, long timestamp, int[] data) {
  // println("Sketch: myoOnEmg");
  // int[] data <- 8 values from -128 to 127

  synchronized (this) {
    for (int i = 0; i<data.length; i++) {
      sensors.get(i).add((int) map(data[i], -128, 127, 0, 50)); // [-128 - 127]
    }
    while (sensors.get (0).size() > width) {
      for (ArrayList<Integer> sensor : sensors) {
        sensor.remove(0);
      }
    }
  }
}

// ----------------------------------------------------------

/*
void myoOn(Myo.Event event, Myo myo, long timestamp) {
 switch(event) {
 case EMG:
 // println("myoOn EMG");
 // int[] data <- 8 values from -128 to 127
 int[] data = myo.getEmg();
 for(int i = 0; i<data.length; i++){
 println(data[i]); // [-128 - 127] 
 }
 break;
 }
 }
 */
