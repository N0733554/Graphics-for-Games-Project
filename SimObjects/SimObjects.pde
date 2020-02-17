SimObjectManager manager;

SimCamera cam;

 

void setup()
{
  size(1920,1080,P3D);
  manager = new SimObjectManager();
  
  //Terrain Setup
  SimSurfaceMesh terrain = new SimSurfaceMesh(10,10,1);
  manager.addSimObject(terrain, "terrain");
  
  // Camera Setup
  cam = new SimCamera();
  PVector camPos = new PVector(5,-5,10);
  PVector camLook = new PVector(5,0,5);
  cam.setPositionAndLookat(camPos, camLook);
  
  // Ball Setup
  PVector ballPos = new PVector(5,-1,5);
  float ballRad = 1f;
  SimSphere ball = new SimSphere(ballPos, ballRad);
  manager.addSimObject(ball, "ball");
}

void draw()
{
  manager.drawAll();
}
