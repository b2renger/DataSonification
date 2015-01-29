import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;


String name1 = "Guillois Loic.xml";
XML xml_1;
ArrayList  points_1;

int start = 0;
int stop = 0;
int position;

int time_step = 500;
int time=0;

void setup() {
  size(400, 270);

  points_1 = new ArrayList();
  xml_1 = loadXML(name1);
  parseXmlNeurosky(xml_1, points_1);

  println("xml1 size : "+points_1.size());
  position = start;
  stop = points_1.size()-1;

  background(255);
  textSize(12);

  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}


void draw() {
  background(255);

  if (millis() > time + time_step) {
    if (position <stop && position>=start) {
      position += 10;
    } else {
      position = start;
    }
    time = millis();
  }

  Point p = (Point) points_1.get(position);
 
  fill(0);
  
  text("refresh rate : "+time_step,25,25);
  text("position : "+position, 25, 45);
  text("attention level : "+p.att, 25, 70);
  text("meditation level : "+p.med, 25, 90);
  text("delta : "+p.delta, 25, 110);
  text("theta : "+p.theta, 25, 130);
  text("low alpha : "+p.lowa, 25, 150);
  text("high alpha : "+p.higha, 25, 170);
  text("low beta : "+p.lowb, 25, 190);
  text("high beta : "+p.highb, 25, 210);
  text("low gamma : "+p.lowb, 25, 230);
  text("high gamma : "+p.highg, 25, 250);
  
 send_osc_message("/attention", p.att);
 send_osc_message("/meditation", p.med);
 send_osc_message("/delta", p.delta);
 send_osc_message("/theta", p.theta);
 send_osc_message("/lowa", p.lowa);
 send_osc_message("/higha", p.higha);
 send_osc_message("/lowb", p.lowb);
 send_osc_message("/highb", p.highb);
 send_osc_message("/lowg", p.lowg);
 send_osc_message("/highg", p.highg);
 
  
}

void send_osc_message(String sender, float value){
   OscMessage myMessage = new OscMessage(sender);
  myMessage.add(value);
  oscP5.send(myMessage, myRemoteLocation); 
}

void mousePressed() {

  if (mouseButton == LEFT) {
    // change speed of the sequencer
    time_step = int(map(mouseX, 0, width, 50, 1500));
    OscMessage myMessage = new OscMessage("/timestep");
    myMessage.add(time_step);
    oscP5.send(myMessage, myRemoteLocation);
  }
}

