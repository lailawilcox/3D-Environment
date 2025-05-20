import java.awt.Robot;

//colour pallette
color black = #000000;
color white = #FFFFFF;

//Textures
PImage stoneBrick;

//Map Variables
int gridSize;
PImage map;

//Robot for Mouse Control
Robot rbt;
boolean skipFrame;

//Camera Variables
float eyeX, eyeY, eyeZ; //camera postition
float focusX, focusY, focusZ; //point at which camera faces
float tiltX, tiltY, tiltZ; //tilt axis

//Keyboard Variables
boolean wkey, akey, skey, dkey;

//Rotation Variables
float leftRightHeadAngle, upDownHeadAngle;

//--------------------------------------------------------
void setup() {
  try {
    rbt = new Robot();
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  fullScreen(P3D);
  textureMode(NORMAL);

  //Initialize Keybord
  wkey = akey = skey = dkey = false;

  //Initialize Camera
  eyeX = width/2;
  eyeY = height/2;
  eyeZ = height/2;

  focusX = width/2;
  focusY = height/2;
  focusZ = height/ - 100;

  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;

  // Initialize Textures
  stoneBrick = loadImage("3D Textures/Stone_Bricks.png");

  //Initialize Map
  map = loadImage("3DMap.png");
  gridSize = 100;

  noCursor();
  skipFrame = false;
}

void draw() {
  background(0);

  //lights();

  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);

  move();
  drawFloor(-2000, 2000, height, 100);
  drawFloor(-2000, 2000, 0, 100);
  drawMap();
}

//--------------------------------------------------------

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c != white) {
        for (int h = 0; h < gridSize*3; h += gridSize) {
          texturedCube(x*gridSize-2000, height-gridSize-h, y*gridSize-2000, stoneBrick, gridSize);
        }
      }
    }
  }
}

void drawFloor(int b, int f, int y, int s) {
  stroke(255);
  for (int i = b; i <= f; i += s) {
    line(i, y, b, i, y, f);
    line(b, y, i, f, y, i);
  }
}

void move() {
  //KeyBoard
  if (wkey) {
    eyeX += cos(leftRightHeadAngle) * 10;
    eyeZ += sin(leftRightHeadAngle) * 10;
  }

  if (skey) {
    eyeX -= cos(leftRightHeadAngle) * 10;
    eyeZ -= sin(leftRightHeadAngle) * 10;
  }

  if (akey) {
    eyeX -= cos(leftRightHeadAngle + PI/2) * 10;
    eyeZ -= sin(leftRightHeadAngle + PI/2) * 10;
  }

  if (dkey) {
    eyeX -= cos(leftRightHeadAngle - PI/2) * 10;
    eyeZ -= sin(leftRightHeadAngle - PI/2) * 10;
  }

  //Focal Point
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();

  //Cursor
  if (!skipFrame) {
    leftRightHeadAngle += (mouseX - pmouseX)*0.01;
    upDownHeadAngle += (mouseY - pmouseY)*0.01;
  }

  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle) * 300;
  focusZ = eyeZ + sin(leftRightHeadAngle) * 300;
  focusY = eyeY + tan(upDownHeadAngle) * 300;

  if (mouseX < 2) {
    rbt.mouseMove(width-2, mouseY);
    skipFrame = true;
  } else if (mouseX > width-2) {
    rbt.mouseMove(2, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
  println(eyeX, eyeY, eyeZ);
}

//--------------------------------------------------------

void keyPressed() {
  if (key == 'w' || key == 'W') wkey  = true;
  if (key == 'a' || key == 'A') akey  = true;
  if (key == 's' || key == 'S') skey  = true;
  if (key == 'd' || key == 'D') dkey  = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') wkey  = false;
  if (key == 'a' || key == 'A') akey  = false;
  if (key == 's' || key == 'S') skey  = false;
  if (key == 'd' || key == 'D') dkey  = false;
}
