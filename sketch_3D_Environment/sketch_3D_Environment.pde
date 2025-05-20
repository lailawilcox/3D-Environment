import java.awt.Robot;

//colour pallette
color black = #000000; //oak planks
color white = #FFFFFF; //empty space
color blue = #7092BE;  //bricks

//Textures
PImage stoneBrick;
PImage oakLogSide;
PImage oakLogTop;
PImage grassBlockTop;
PImage grassBlockSide;
PImage grassBlockBottom;

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
  eyeY = 8*height/10;
  eyeZ = height/2;

  focusX = width/2;
  focusY = height/2;
  focusZ = height/ - 100;

  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;

  // Initialize Textures
  stoneBrick = loadImage("3D Textures/Stone_Bricks.png");
  oakLogSide = loadImage("3D Textures/Oak_Log_Side.png");
  oakLogTop = loadImage("3D Textures/Oak_Log_Top.png");
  grassBlockTop = loadImage("3D Textures/Grass_Block_Top.png");
  grassBlockSide = loadImage("3D Textures/Grass_Block_Side.png");
  grassBlockBottom = loadImage("3D Textures/Grass_Block_Bottom.png");

  //Initialize Map
  map = loadImage("3DMap.png");
  gridSize = 100;

  noCursor();
  skipFrame = false;
}

void draw() {
  background(0);

  //lights();
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);

  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);

  move();
  drawFloor(-2000, 2000, height, gridSize);                //floor
  drawCeiling(-2000, 2000, height-gridSize*5, gridSize);   //ceiling
  drawMap();
}

//--------------------------------------------------------

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);

      if (c == blue) {
        for (int h = 0; h < gridSize*4; h += gridSize) {
          texturedCube(x*gridSize-2000, height-gridSize-h, y*gridSize-2000, stoneBrick, gridSize);
        }
      }

      if (c == black) {
        for (int h = 0; h < gridSize*4; h += gridSize) {
          texturedCube(x*gridSize-2000, height-gridSize-h, y*gridSize-2000, oakLogTop, oakLogSide, oakLogTop, gridSize);
        }
      }
    }
  }
}

void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, grassBlockTop, grassBlockSide, grassBlockBottom, gap);
    x += gap;
    if (x >= end) {
      x = start;
      z += gap;
    }
  }
}

void drawCeiling(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, stoneBrick, gap);
    x += gap;
    if (x >= end) {
      x = start;
      z += gap;
    }
  }
}

void move() {
  //KeyBoard
  if (wkey && canMoveForward()) {
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

boolean canMoveForward() {
  float fwdx, fwdy, fwdz;
  int mapx, mapy;

  fwdx = eyeX + cos(leftRightHeadAngle) * 100;
  fwdy = eyeY;
  fwdz = eyeZ + sin(leftRightHeadAngle) * 100;

  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;

  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
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
