import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

Table angers, cholet, laroche, laval, lemans, saintnazaire;

int start = 0;
int stop = 3288;
int position;

int time_step = 500;
int time=0;

void setup() {
  size(300, 720);

  background(255);
  textSize(12);
  
  angers = loadTable("Environnement_INDICE_ATMO_JOUR_ANGERS_STBL.csv","header");
  cholet = loadTable("Environnement_INDICE_ATMO_JOUR_CHOLET_STBL.csv","header");
  laroche = loadTable("Environnement_INDICE_ATMO_JOUR_LAROCHE_STBL.csv","header");
  laval = loadTable("Environnement_INDICE_ATMO_JOUR_LAVAL_STBL.csv","header");
  lemans = loadTable("Environnement_INDICE_ATMO_JOUR_LEMANS_STBL.csv","header");
  saintnazaire = loadTable("Environnement_INDICE_ATMO_JOUR_SAINTNAZAIRE_STBL.csv","header");
  
  position = start;

  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  background(255);

  if (millis() > time + time_step) {
    if (position <stop && position>=start) {
      position += 1;
    } else {
      position = start;
    }
    time = millis();
  }
  
  fill(0); 
  text("Refresh rate : "+time_step,25,25);
  
  text("Date : "+ angers.getString(position,"DATE"),25,50);
  
  translate(0,80);
  display_n_send(angers, "angers");
  
  translate(0,110);
  display_n_send(cholet, "cholet");
  
  translate(0,110);
  display_n_send(laroche, "laroche");
  
  translate(0,110);
  display_n_send(laval, "laval");
  
  translate(0,110);
  display_n_send(lemans, "lemans");
  
  translate(0,110);
  display_n_send(saintnazaire, "sn");
  
}

void display_n_send(Table table, String string){
  text(string+" Air quality : "+ table.getFloat(position,"INDICE_QUALITE_AIR"),25,0);
  text(string+" Ozone : "+ table.getFloat(position,"SOUS_INDICE_OZONE"),25,15);
  text(string+" Particules fines : "+ table.getFloat(position,"SOUS_INDICE_PARTICULES_FINES"),25,30);
  text(string+" Dioxyde d'azote : "+ table.getFloat(position,"SOUS_INDICE_DIOXYDE_D'AZOTE"),25,45);
  text(string+" Dioxyde de souffre : "+ table.getFloat(position,"SOUS_INDICE_DIOXYDE_DE_SOUFRE"),25,60);
  text(string+" couleur :"+table.getString(position,"CODE_COULEUR"),25,75);
  
  send_osc_message("/"+string+"AirQuality", table.getFloat(position,"INDICE_QUALITE_AIR"));
  send_osc_message("/"+string+"Ozone", table.getFloat(position,"SOUS_INDICE_OZONE"));
  send_osc_message("/"+string+"Particules", table.getFloat(position,"SOUS_INDICE_PARTICULES_FINES"));
  send_osc_message("/"+string+"Azote", table.getFloat(position,"SOUS_INDICE_DIOXYDE_D'AZOTE"));
  send_osc_message("/"+string+"Souffre", table.getFloat(position,"SOUS_INDICE_DIOXYDE_DE_SOUFRE"));
  send_osc_str_message("/"+string+"Couleur", table.getString(position,"CODE_COULEUR"));
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

