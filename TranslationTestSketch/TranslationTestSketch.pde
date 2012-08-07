color fillColor = color(random(150)+100,random(150)+50, random(150)+50);
float x;
float w = 50;

void setup() {
  size(400, 400);
  background(255);
  smooth();
}

void draw() {
  background(255);
  x = x + 0.8;
  
  if (x > 400 + w) {
    x = -w;
  } 
  
  //translate(x, height/2-w/2);
  pushMatrix();
  translate(x, 50);
  fill(255);
  //rect(-w/2, -w/2, w, w);
    ellipse(-w/2, 50, w, w);
  popMatrix();
  
  //translate(x, height/2-w/2);
  pushMatrix();
  translate(x, 100);
  fill(255);
  //rect(-w/2, -w/2, w, w);
    ellipse(-w/2, 100, w, w);
  popMatrix();
}
