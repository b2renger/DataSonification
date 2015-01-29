void parseXmlNeurosky (XML myXml, ArrayList myArrayList) {
  // what are the childs of our xml ?
  int numChild = myXml.getChildCount();
  //println("nb child root= " + numChild);

  XML kid;  // create a new element to be scaned to know the structure of ou xml file
  for (int i = 0; i < numChild; i++) {
    kid = myXml.getChild(i);
    //println("name :"+kid.getName()+"<-");
  }
  // skip the info ... go directly to the List of neuroskypoints

  XML list;
  list = myXml.getChild("LIST");
  // our new XML is called list it has all the data stored in certain number of "NeuroSkyPoint"
  int numPoints = list.getChildCount();
  //println("nb points = "+numPoints);
  //println(list.hasChildren());

  // store our list of points in an array
  XML[] pointxml = list.getChildren("NeuroSkyPoint");

  // Iterate through each element of the array
  // getContent for each child => convert to float => store it using our Point data structure => put the new Point in the points arrayList
  for (int i = 0; i < pointxml.length; i++) {
    //println("id :"+i+"<-");
    // time code
    String videoTime = pointxml[i].getChild("videoTime").getContent();
    // println("videoTime : " + videoTime);
    float de_videoTime= new Float(videoTime); // strore it with a trick to transform string to float <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<potential js error
    de_videoTime = round(de_videoTime*10.f)/10.f; // and another trick to get rid of some decimals
    //float de_videoTime = pointxml[i].getFloat("videoTime");
    //println(de_videoTime);

    // Données Affectives
    String attention = pointxml[i].getChild("Attention").getContent();
    //println("attention : " + attention);
    float de_attention= new Float(attention);

    String meditation = pointxml[i].getChild("Meditation").getContent();
    //println("meditation : " + meditation);
    float de_meditation = new Float(meditation);

    String raw = pointxml[i].getChild("Raw").getContent();
    //println("raw : " + raw);
    float de_raw = new Float(raw);

    String delta = pointxml[i].getChild("delta").getContent();
    //println("delta : " + delta);   
    float de_delta = new Float(delta);

    String theta = pointxml[i].getChild("theta").getContent();
    //println("theta : " + theta);
    float de_theta = new Float(theta);

    String lowalpha = pointxml[i].getChild("lowAlpha").getContent();
    //println("lowalpha : " + lowalpha);
    float de_lowalpha = new Float(lowalpha);

    String highalpha = pointxml[i].getChild("highAlpha").getContent();
    //println("highalpha : " + highalpha);
    float de_highalpha = new Float (highalpha);

    String lowbeta = pointxml[i].getChild("lowBeta").getContent();
    //println("lowbeta : " + lowbeta);
    float de_lowbeta = new Float (lowbeta);

    String highbeta = pointxml[i].getChild("highBeta").getContent();
    //println("highbeta : " + highbeta);
    float de_highbeta = new Float (highbeta);

    String lowgamma = pointxml[i].getChild("lowGamma").getContent();
    //println("lowgamma : " + lowgamma);
    float de_lowgamma = new Float (lowgamma);

    String highgamma = pointxml[i].getChild("highGamma").getContent();
    //println("highgamma : " + highgamma);
    float de_highgamma = new Float (highgamma);

    // on remplit notre arrayList avec notre objet Point
    myArrayList.add(new Point(de_videoTime, de_attention, de_meditation, de_raw, de_delta, de_theta, de_lowalpha, de_highalpha, de_lowbeta, de_highbeta, de_lowgamma, de_highgamma));
  }
}

