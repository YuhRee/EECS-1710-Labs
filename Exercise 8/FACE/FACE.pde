//IMPORTANT: Must use Processing 3.5.4!
//Will not work on beta version 4

/*REFERENCES:
 https://www.youtube.com/watch?v=YX41KXbMf_U&t=111s
 */

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture cam;
float[][] kernel = {{ -1, -1, -1, -1, -1},
  { -1, -1, 9, -1, -1},
  { -1, -1, -1, -1, -1}};
OpenCV openCVFace;
OpenCV openCVEye;
OpenCV openCVNose;
PImage head;
PImage bangs;
PImage hairBack;
PImage eye;
PImage nose;


void setup() {
  size(640, 480);
  head = loadImage("head.png");
  bangs = loadImage("bangs.png");
  hairBack = loadImage("hairBangs.png");
  eye = loadImage("eye.png");
  nose = loadImage("nose.png");

  //camera capture and opencv
  cam = new Capture(this, width, height);
  openCVFace = new OpenCV(this, width, height);
  openCVEye = new OpenCV(this, width, height);
  openCVNose = new OpenCV(this, width, height);
  //search for this
  openCVFace.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  openCVEye.loadCascade(OpenCV.CASCADE_EYE); 
  openCVNose.loadCascade(OpenCV.CASCADE_NOSE); 

  cam.start();
}

void draw() {

  openCVFace.loadImage(cam);
  openCVEye.loadImage(cam);
  openCVNose.loadImage(cam);
  image(cam, 0, 0);
  cam.loadPixels();
  PImage edgecam = createImage(cam.width, cam.height, RGB);
  
    for (int y = 1; y < cam.height-1; y++) { // Skip top and bottom edges
    for (int x = 1; x < cam.width-1; x++) { // Skip left and right edges

      float sum = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*cam.width + (x + kx);
          // Image is grayscale, red/green/blue are identical
          float val = red(cam.pixels[pos]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+1][kx+1] * val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      edgecam.pixels[y*cam.width + x] = color(sum, sum, sum);

      int loc = x + y*edgecam.width;
      color pix = edgecam.pixels[loc];
      int c = 255*(round((((pix >> 16 & 0xFF)+(pix >> 8 & 0xFF)+(pix & 0xFF))/3)/255.0));
      edgecam.pixels[y*edgecam.width + x] = color(c, c, c);
    }
  }
  edgecam.updatePixels();
  //show updated image
  image(edgecam, 0, 0);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = openCVFace.detect();
  Rectangle[] eyes = openCVEye.detect();
  Rectangle[] noses = openCVNose.detect();
  for (int i = 0; i < faces.length; i++) {
    //for the eyes
    for (int j = 0; j < eyes.length; j++) {
      for (int l = 0; l < noses.length; l++) {
        //eye is in face
        if (dist(faces[i].x, faces[i].y, eyes[j].x, eyes[j].y) < faces[i].width/2 + eyes[j].width/2) {
          float headRatio = faces[i].height; //used to stretch the face parts correctly (is currently same as face height)
          image(hairBack, faces[i].x-headRatio/4, faces[i].y-headRatio/3, faces[i].width+headRatio/2, faces[i].height+headRatio/5);
          image(head, faces[i].x, faces[i].y-headRatio/3, faces[i].width, faces[i].height+headRatio/3);

          //draws both eyes (limited to only 2)
          for (int k = 0; k < 2; k++) {
            if (eyes[k].y < noses[l].y) {
              image(eye, eyes[k].x, eyes[k].y, eyes[k].width, eyes[k].height);
            }
          }

          //nose is in face
          if (dist(faces[i].x, faces[i].y, noses[l].x, noses[l].y) < faces[i].width/2 + noses[l].width/2) {
            image(nose, noses[l].x, noses[l].y, noses[l].width, noses[l].height);
          }

          image(bangs, faces[i].x-headRatio/4, faces[i].y-headRatio/2, faces[i].width+headRatio/2, faces[i].height+headRatio/5);
        }
      }
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}
