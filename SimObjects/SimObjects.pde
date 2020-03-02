SimObjectManager manager;

SimCamera cam; 

int terrainCols = 10;
int terrainRows = 10;
float terrainScale = 1;

float terrainWidth = terrainCols * terrainScale;
float terrainHeight = terrainRows * terrainScale;

float gStrength = 1;

void setup()
{
  size(800,600,P3D);
  manager = new SimObjectManager();
  
  //Terrain Setup
  SimSurfaceMesh terrain = new SimSurfaceMesh(terrainCols,terrainRows,terrainScale);
  terrain.setTransformAbs(vec(-terrainWidth/2, 0, -terrainHeight/2),1,0,0,0);
  manager.addSimObject(terrain, "terrain");
  
  // Camera Setup
  cam = new SimCamera();
  PVector camPos = new PVector(0,-5,10);
  PVector camLook = new PVector(0,0,0);
  cam.setPositionAndLookat(camPos, camLook);
  
  // Ball Setup
  PVector ballPos = new PVector(0,-3,0);
  float ballRad = 1f;
  SimSphere ball = new SimSphere(ballPos, ballRad);
  ball.setVelocity(vec(0,0.01,0));
  manager.addSimObject(ball, "ball");
}

long lastTime = 0;
long delta = 0;

void draw()
{
  background(255);
  
  //applyGravity(manager.getSimObject("ball"));  
  
  manager.moveAll();
  
  manager.drawAll();
}

void applyGravity(SimTransform s)
{  
  s.applyForce(vec(0,gStrength,0));
}
