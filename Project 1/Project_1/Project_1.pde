int Quantity = 5000;
float spring = 0.50;
float gravity = -0.02;
float friction = -0.9;
Ball[] balls = new Ball[Quantity];

void setup() {
  size(400, 800);
  for (int i = 0; i < Quantity; i++) {
    balls[i] = new Ball(random(width), random(height), random(5, 15), i, balls);
  }
  noStroke();
  fill(255, 255);
}

void draw() {
  background(25,12);
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();  
  }
}
