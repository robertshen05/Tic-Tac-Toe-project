//server (sends x's (2))
import processing.net.*;
Server myServer;

color green = #519548;
color red = #B90504;

boolean itsMyTurn = true;

int [][] grid;

void setup() {
  size(300, 400);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  myServer = new Server(this, 1234);
}

void draw() {
  if (itsMyTurn)
    background(green);
  else
    background(red);

  stroke(0);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);

  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++)
      drawXO(row, col);
  }
  fill(0);
  text(mouseX + "," + mouseY, 150, 300);
  Client myclient = myServer.available();
  if (myclient != null) {
    String incoming = myclient.readString(); 
    int r = int(incoming.substring(0, 1));
    int c = int(incoming.substring(2, 3));
    grid[r][c] = 1;
    itsMyTurn = true;
  }
} 

void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid [row][col] == 1) {
    fill (255);
    ellipse(50, 50, 90, 90);
  } else if (grid[row][col] == 2) {
    line (10, 10, 90, 90);
    line (90, 10, 10, 90);
  }
  popMatrix();
}

void mouseReleased() {
  int row = mouseX/100;
  int col = mouseY/100;
  if (itsMyTurn && grid[row][col] == 0) {
    myServer.write(row + "," + col);
    grid[row][col] = 2;
    itsMyTurn = false;
    println(row + "," + col);
  }
} 
