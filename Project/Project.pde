SimCamera cam;
SimObjectManager manager;
Timer timer;

SimSurfaceMesh terrain;
MovableSphere ball;

int numCol = 10;
int numRow = 10;
float Scale = 10;

float terrainWidth = numCol * Scale;
float terrainDepth = numRow * Scale;

float camHeight = 30;
float ballHeight = 20;

void setup()
{
  size(800,600,P3D);  
  manager = new SimObjectManager();
  timer = new Timer();
  
  cam = new SimCamera();
  cam.setPositionAndLookat(vec(0,-camHeight, terrainWidth/2),vec(0,0,0));
  
  terrain = new SimSurfaceMesh(numCol,numRow,Scale);
  terrain.setTransformAbs(vec(-terrainWidth/2, 0, -terrainDepth/2),1,0,0,0);
  //manager.addSimObject(terrain, "terrain");
  
  ball = new MovableSphere();
  ball.setTransformAbs(vec(0,-ballHeight,0),2,0,0,0); 
  
}

float delta;

void draw()
{  
  delta = timer.getElapsedTime();
  background(255);  
  
  ball.moveMe(delta);
  
  terrain.drawMe();
  ball.drawMe();
}
