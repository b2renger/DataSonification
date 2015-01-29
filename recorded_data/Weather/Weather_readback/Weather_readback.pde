import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

Table weather_table;


int start = 0;
int stop = 0;
int position;

int time_step = 500;
int time=0;

void setup() {
  size(400, 320);

  background(255);
  textSize(12);

  weather_table = loadTable("Weather_Data_Nantes_1996_2015.csv", "header");

  position = start;
  stop = weather_table.getRowCount()-1;

  println("csv size : ", weather_table.getRowCount());


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
  text("refresh rate : "+time_step, 25, 25);
  text("date : "+weather_table.getString(position, "CET"), 25, 50);
  text("max temp : "+weather_table.getString(position, "Max TemperatureC"), 25, 80);
  text("min temp : "+weather_table.getString(position, "Min TemperatureC"), 25, 100);
  text("mean temp : "+weather_table.getString(position, "Mean TemperatureC"), 25, 120);

  text("mean dew : "+weather_table.getString(position, "MeanDew PointC"), 25, 150);
  text("mean humidity : "+weather_table.getString(position, " Mean Humidity"), 25, 170);
  text("mean pressure : "+weather_table.getString(position, " Mean Sea Level PressurehPa"), 25, 190);
  text("mean visibility : "+weather_table.getString(position, " Mean VisibilityKm"), 25, 210);
  text("mean wind speed : "+weather_table.getString(position, " Mean Wind SpeedKm/h"), 25, 230);
  text("speed direction : "+weather_table.getString(position, "WindDirDegrees"), 25, 250);
  text("precipitation : "+weather_table.getString(position, "Precipitationmm"), 25, 270);
  text("cloud cover : "+weather_table.getString(position, " CloudCover"), 25, 290);
  text("Events : "+weather_table.getString(position, " Events"), 25, 310);
  
  send_osc_message("/maxTemp",weather_table.getFloat(position, "Max TemperatureC"));
  send_osc_message("/minTemp",weather_table.getFloat(position, "Min TemperatureC"));
  send_osc_message("/meanTemp",weather_table.getFloat(position, "Mean TemperatureC"));
  
  send_osc_message("/dew",weather_table.getFloat(position, "MeanDew PointC"));
  send_osc_message("/humidity",weather_table.getFloat(position, " Mean Humidity"));
  send_osc_message("/pressure",weather_table.getFloat(position, " Mean Sea Level PressurehPa"));
  send_osc_message("/visibility",weather_table.getFloat(position, " Mean VisibilityKm"));
  send_osc_message("/windSpeed",weather_table.getFloat(position, " Mean Wind SpeedKm/h"));
  send_osc_message("/windDirection",weather_table.getFloat(position, "WindDirDegrees"));
  send_osc_message("/cloud",weather_table.getFloat(position," CloudCover"));
  
  send_osc_str_message("/event",weather_table.getString(position," Events"));
  
  
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

