//Take audio input
//evaluate input amplitude
//if exceeding a certain amount, play an audio clip

void settings() {
  size(640, 360);
}

//declarations
import processing.sound.*;
Amplitude amp;
AudioIn in;
SoundFile shutUp;
final int size = (width+height)/2;

//colors taken from previous assignment
color ellipse_color = color(0, 0, 0);
color quiet = color(31, 124, 171);
color loud = color(214, 17, 60); 

//functions

color mix (color i, color j, float mix) {
  //takes two range values, and mixes them by a certain degree
  color c = lerpColor(i, j, mix);
  int r, g, b;
  r = c >> 16 & 0xFF;
  g = c >> 8 & 0xFF;
  b = c & 0xFF;

  color ret = color(r, g, b);

  return ret;
}

//main functions
void setup() {
  background(255);

  //audio input stream
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  
  //import sound file
  shutUp = new SoundFile(this, "data/shut up.mp3");
  
}

void draw() {
  println(amp.analyze());
  ellipse_color = mix(quiet, loud, amp.analyze());
  fill(ellipse_color);
  ellipse(width/2, height/2, size, size);
  
  if (amp.analyze() > 0.2){
    shutUp.play();
    println("shut up");
  }
}
