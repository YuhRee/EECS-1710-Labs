import processing.video.*;
 
Capture Cam;
int switcher = 0;
 
void setup(){
size(640,480);
Cam = new Capture(this, 640, 480);
Cam.start();
}
 
void draw(){
  tint(0);
  background(256,256,256);
 
 
 
 if (Cam.available()){
    Cam.read();
 }
 if(switcher==0){
 image(Cam,0,0);
 }
 
 else if(switcher == 1){
 scale(-1,1);
 image(Cam,-width,0); 
 }
 
else if(switcher == 2){
 scale(-1,-1);
 image(Cam,-width,-height);
 }
 
else if(switcher == 3){
  //show 4 images
  //change their colors
 
  tint(256, 0, 0);
  image(Cam, 0, 0, width/2, height/2);
 
  tint(0, 256, 0);
  image(Cam, width/2, 0, width/2, height/2);
 
  tint(0, 0, 256);
  image(Cam, 0, height/2, width/2, height/2);
 
  tint(256, 0, 256);
  image(Cam, width/2, height/2, width/2, height/2);
 
 }
 
else if(switcher==4 ){
 
 image(Cam, mouseX,mouseY, width/2, height/2);
 }
 
 
 else{
   println("Switcher = 0 again");
   switcher = 0;
 }
 
}
 
void mousePressed(){
  switcher++;
 
 
 
}
