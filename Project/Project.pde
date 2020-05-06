SimObjectManager manager;
Timer timer;
SimpleUI myUI;
SimCamera cam;

SimSurfaceMesh terrain;
MovableSphere ball;

int numCol = 180;
int numRow = 60;
float Scale = 2;

float terrainWidth = numCol * Scale;
float terrainDepth = numRow * Scale;

float camHeight = 10;
float ballHeight = -20;
PVector ballStart = vec(terrainWidth/16,-ballHeight,terrainDepth/2);

boolean isFiring = false;
boolean isDrawLines = false;

PVector firingVector;
float firingForce = 0;
float firingHeight = 0;
float firingAngle = 0;


Rect hudArea;

void setup()
{
  size(800,600,P3D);  
  manager = new SimObjectManager();
  timer = new Timer();
  
  cam = new SimCamera();
  cam.setHUDArea(20,20,150,290);
  PVector camPos = vec(-terrainWidth/8,-camHeight,terrainDepth/2);
  PVector lookPos = vec(terrainWidth/3, 0, terrainDepth/2);
  cam.setPositionAndLookat(camPos, lookPos);
  
  myUI = new SimpleUI();  
  myUI.addPlainButton("Fire!", 30,40);
  myUI.addPlainButton("Reset",30,80);
  myUI.addSlider("Firing Power",30,120);
  myUI.addSlider("Firing Height",30,160);
  myUI.addSlider("Firing Angle",30,200);
  myUI.addToggleButton("Draw Lines",30,240);
  
  terrain = new SimSurfaceMesh(numCol,numRow,Scale);
  terrain.setID("terrain");
  PImage bumpy = loadImage("fractalNoise.png");
  terrain.setHeightsFromImage(bumpy, 50f);
  terrain.setTransformAbs(vec(0, 0, 0),1,0,0,0);
  //manager.addSimObject(terrain, "terrain");
  
  fill(200);
  
  ball = new MovableSphere();
  ball.setID("ball");
  ball.setPosition(ballStart.x,ballStart.y,ballStart.z);
  ball.setMass(3);
  
  
  
}

float delta;

void draw()
{  
  delta = timer.getElapsedTime();
  background(0);  
  
  if(isDrawLines)
  {
    calcFiringVector();
    stroke(255,0,0);
    strokeWeight(10);
    PVector point = ball.position.copy().add(firingVector);
    line(ball.position.x, ball.position.y, ball.position.z, point.x, point.y, point.z);
  }
  if(isFiring)
  {
  ball.applyGravity();  
  
  ball.moveMe(delta, terrain);
  }
  stroke(0);
  strokeWeight(1);
  terrain.drawMe();
  strokeWeight(0);
  noStroke();
  ball.drawMe();
  
  drawUI();
}

void keyPressed() {
  if(key == 'w')
  {
    ball.addForce(vec(0,-100,0));
  }
  if(key == 's')
  {
    ball.addForce(vec(0,100,0));
  }
  
  if(key == 'r')
  {
    reset();
  }
}

void drawUI()
{
  cam.startDrawHUD();
  myUI.update();
  cam.endDrawHUD();
}

void reset()
{  
    ball.velocity = vec(0,0,0);
    ball.setPosition(ballStart.x,ballStart.y,ballStart.z);
    isFiring = false;
}

void fire()
{
    reset();
    isFiring = true;
    
    calcFiringVector();
    
    ball.addForce(firingVector);
}

void handleUIEvent(UIEventData uied){
  // here we just get the event to print its self
  // with "verbosity" set to 1, (2 = medium, 3 = high, 0 = do not print anything)
  uied.print(1);
  
  
  /////////////////////////////////////////////////////////////
  // this stuff opens the file dialogue window, and then when you have
  // clicked the "open" button, ....
  if(uied.uiLabel.equals("Fire!") ){
    fire();
  }  
  if(uied.uiLabel.equals("Reset") ){
    reset();  
  }
  
  if(uied.uiLabel.equals("Firing Power") ){ // Firing power should be between 0 and 1000
    firingForce = uied.sliderValue * 10000;
  }
  if(uied.uiLabel.equals("Firing Height") ){ // Firing Height should be between 0 degrees and 45 degrees
    firingHeight = uied.sliderValue * -45;
    firingHeight = radians(firingHeight);
  }
  if(uied.uiLabel.equals("Firing Angle") ){ // Firing Angle should be between -45 and 45 degrees
    firingAngle = ((uied.sliderValue * 2)-1)*10;
    firingAngle = radians(firingAngle);
  }
  
  if(uied.uiLabel.equals("Draw Lines") ){
    if(isDrawLines)
      isDrawLines = false;
    else
      isDrawLines = true;
  }
}

void calcFiringVector()
{
    float x = cos(firingAngle) * cos(firingHeight);
    float y = sin(firingHeight);
    float z = sin(firingAngle) * cos(firingHeight);
    firingVector = vec(x,y,z);
    firingVector.normalize();
    firingVector.mult(firingForce);
}
