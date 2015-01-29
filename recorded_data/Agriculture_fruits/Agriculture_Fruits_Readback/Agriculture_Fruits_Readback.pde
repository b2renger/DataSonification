import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

Table abricots, cerises, fraises, kiwis, melons, nectarines, peches, poires, pommes,prunes,raisin;

int start = 172;
int stop = 1;
int position;

int time_step = 500;
int time=0;

void setup() {
  size(400, 270);

  background(255);
  textSize(12);

  abricots = loadTable("Agriculture_Abricot.csv", "header");
  cerises = loadTable("Agriculture_Cerises.csv", "header");
  fraises = loadTable("Agriculture_Fraises.csv", "header");
  kiwis = loadTable("Agriculture_Kiwis.csv", "header");
  melons = loadTable("Agriculture_Melon.csv", "header");
  nectarines = loadTable("Agriculture_Nectarines.csv", "header");
  peches = loadTable("Agriculture_peches.csv", "header");
  poires = loadTable("Agriculture_poires.csv", "header");
  pommes = loadTable("Agriculture_pommes.csv", "header");
  prunes = loadTable("Agriculture_Prune.csv", "header");
  raisin = loadTable("Agriculture_Raisin.csv", "header");

  position = start;


  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 9876);
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
  text("refresh rate : "+time_step, 25, 25);

  text(abricots.getString(position, "Annee")+"-"+abricots.getString(position, "Mois"), 25, 50);

  translate(0, 75);
  display_n_send(abricots, "abricots");

  translate(0, 15);
  display_n_send(cerises, "cerises");

  translate(0, 15);
  display_n_send(fraises, "fraises");

  translate(0, 15);
  display_n_send(kiwis, "kiwis");

  translate(0, 15);
  display_n_send(melons, "melons");

  translate(0, 15);
  display_n_send(nectarines, "nectarines");

  translate(0, 15);
  display_n_send(peches, "peches");

  translate(0, 15);
  display_n_send(poires, "poires");

  translate(0, 15);
  display_n_send(pommes, "pommes");
  
  translate(0, 15);
  display_n_send(prunes, "prunes");
  
  translate(0, 15);
  display_n_send(raisin, "raisin");
}

void display_n_send(Table table, String string) { 
  float val = table.getFloat(position, "Valeur");
  text(string+"  : "+ val, 25, 0); 
  if (val>=0) {
    send_osc_message("/"+string, val);
  } else {
    send_osc_message("/"+string, -1);
  }
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

