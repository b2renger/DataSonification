import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

Table fruits, legumes, maree, lait,viandes;

int start = 178;
int stop = 1;
int position;

int time_step = 500;
int time=0;

void setup() {
  size(400, 270);

  background(255);
  textSize(12);
  
  fruits = loadTable("Agriculture_Fruits.csv","header");
  legumes = loadTable("Agriculture_Legumes.csv","header");
  maree = loadTable("Agriculture_Maree.csv","header");
  lait = loadTable("Agriculture_Oeufs_Produits_Laitiers.csv","header");
  viandes = loadTable("Agriculture_Viandes.csv","header");
  
  position = start;
 
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  background(255);

  if (millis() > time + time_step) {
    if (position >stop && position<=start) {
      position -= 1;
    } else {
      position = start;
    }
    time = millis();
  }
  
  fill(0); 
  text("refresh rate : "+time_step,25,25);
  
  text(fruits.getString(position,"année")+"-"+fruits.getString(position,"mois"),25,50);
  
  translate(0,70);
  display_n_send(fruits,"fruits");
  translate(0,15);
  display_n_send(legumes,"legumes");
  translate(0,15);
  display_n_send(maree,"maree");
  translate(0,15);
  display_n_send(lait,"lait");
  translate(0,15);
  display_n_send(viandes,"viandes");
  
}

void display_n_send(Table table, String string){ 
  text(string+"  : "+ table.getFloat(position,"valeur"),25,0); 
  send_osc_message("/"+string, table.getFloat(position,"valeur"));  
}

void send_osc_message(String sender, float value) {
  OscMessage myMessage = new OscMessage(sender);
  myMessage.add(value);
  oscP5.send(myMessage, myRemoteLocation);
}

void send_osc_str_message(String sender, String value) {
  OscMessage myMessage = new OscMessage(sender);
  myMessage.add(value);
  oscP5.send(myMessage, myRemoteLocation);
}


void mouseDragged() {

  if (mouseButton == LEFT) {
    // change speed of the sequencer
    time_step = int(map(mouseX, 0, width, 50, 1500));
    OscMessage myMessage = new OscMessage("/timestep");
    myMessage.add(time_step);
    oscP5.send(myMessage, myRemoteLocation);
  }
}

