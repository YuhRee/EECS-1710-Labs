int w = 800;
int h = 500;
int mainSize = 50; //size of each core edge
Col baseColor = new Col(14,14,14);
//the core of the pattern
Pattern pattern = new Pattern(0, 0, mainSize);
Pattern[] grid = new Pattern[87];

void settings() {
  size(w, h, P2D);
}

//location point
//reused from Ex 2
class Point {
  float x;
  float y;

  Point () {
    x = 0;
    y = 0;
  }
  Point (float a, float b) {
    x = a;
    y = b;
  }
}

//deals with colors and operations (hue, brightness, etc.)
class Col {
  int r;
  int g;
  int b;

  Col () {
    r = 0;
    g = 0;
    b = 0;
  }
  Col (int c, int d, int e) {
    r = c;
    g = d;
    b = e;
  }

  void setAs (Col c) {
    r = c.r;
    g = c.g;
    b = c.b;
  }

  color toColor () {
    return color(r, g, b);
  }
  void randColor () {
    r = (int)random(1, 256);
    g = (int)random(1, 256);
    b = (int)random(1, 256);
  }
  void brighten (int a) {
    r += a;
    g += a;
    b += a;
  }
  void hueUp (int a) {
    r += a;
    if (r > 255) {
      r = 255;
      g += a;
      if (g > 255) {
        g = 255;
        b += a;
        if (b > 255) {
          b = 255;
        }
      }
    }
  }
  void mix (Col i, Col j) {
    color c = lerpColor(i.toColor(), j.toColor(), 0.01);
    r = c >> 16 & 0xFF;
    g = c >> 8 & 0xFF;
    b = c & 0xFF;
  }
}

//the core of the pattern
class Pattern {
  Point p = new Point();
  int size;
  float triHeight = size*(sqrt(3)/2);
  float fullWidth = triHeight*2;

  Pattern () {
    p.x = 0; //x coordinate
    p.y = 0; //y coordinate
    size = 1;
  }

  Pattern (int x, int y, int s) {
    p.x = x;
    p.y = y;
    size = s;
    triHeight = size*(sqrt(3)/2);
    fullWidth = triHeight*2;
  }

  void move (float x, float y) {
    p.x += x;
    p.y += y;
  }

  void show () {
    //uses verticies from beginShape/endShape to draw each core

    noStroke();

    //TOP DIAMOND________
    pushMatrix();
    translate(p.x+size/2, p.y);
    rotate((30*PI)/180);

    beginShape();
    fill(baseColor.toColor());
    vertex(0, 0); //right point (rotational origin)
    vertex(-size/2, -size*(sqrt(3)/2)); //top point
    vertex(-size, 0); //left point
    vertex(-size/2, size*(sqrt(3)/2)); //bottom point
    endShape(CLOSE);

    popMatrix();

    //RIGHT DIAMOND________
    pushMatrix();
    translate(p.x+size/2, p.y);
    rotate((150*PI)/180);

    beginShape();
    Col temp = new Col(0, 0, 0);
    temp.setAs(baseColor);
    temp.hueUp(60);
    fill(temp.toColor());
    vertex(0, 0); //right point (rotational origin)
    vertex(-size/2, -size*(sqrt(3)/2)); //top point
    vertex(-size, 0); //left point
    vertex(-size/2, size*(sqrt(3)/2)); //bottom point
    endShape(CLOSE);

    popMatrix();

    //BOTTOM DIAMOND________
    pushMatrix();
    translate(p.x+size/2, p.y);
    rotate((270*PI)/180);

    beginShape();
    temp.hueUp(60);
    fill(temp.toColor());
    vertex(0, 0); //right point (rotational origin)
    vertex(-size/2, -size*(sqrt(3)/2)); //top point
    vertex(-size, 0); //left point
    vertex(-size/2, size*(sqrt(3)/2)); //bottom point
    endShape(CLOSE);

    popMatrix();
  }
}

void setup() {
  background(#cccccc);
  
  int wfit = ceil(w/pattern.fullWidth)+1; //number of cores that fit in width
  for(int i = 0; i < grid.length; i++){
    grid[i] = new Pattern(0, 0, mainSize);
    grid[i].p.x = (pattern.fullWidth)*(i % wfit) - (pattern.fullWidth/2)*((i/wfit)%2); //position + buffer
    grid[i].p.y = (i/wfit)*(1.5*pattern.size);
  }
}


void draw() {
  //"clears" the canvas by covering it with a rectangle
  //fill(#ffffff);
  //rect(0, 0, w, h);
  
  for (int i = 0; i < grid.length; i++) {
    grid[i].show();
  }
}
