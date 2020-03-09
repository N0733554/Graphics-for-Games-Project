class MovableSphere extends SimSphere
{
  float mass = 1.0;
  
  PVector position = new PVector(0,0,0);
  PVector velocity = new PVector(0,0,0);
  PVector force = new PVector(0,0,0);
  PVector acceleration = new PVector(0,0,0);
  
  void setMass(float m){
    
    mass = m;
  }
  
  void setPosition(int x, int y, int z){    
    position = vec(x,y,z);
    this.setTransformAbs(position, 1, 0,0,0);
  }

  public void moveMe(float delta) {
    // assume a number of forces have beed added by the system
    damp();
    calculateAcceleration(delta);
    
    velocity.add( acceleration );
    position.add( PVector.mult(velocity,delta) );
    setTranslation();
    
    resetForceAndAcceleration();
  } 
  
  public void addForce(PVector f){
    force.add(f);
  }
  
  void resetForceAndAcceleration(){
    force = new PVector(0,0);
    acceleration = new PVector(0,0);
  }
  
  
  void calculateAcceleration(float delta){
    // acceleation = force over time / mass
    acceleration = PVector.mult(force, delta / mass);
  }
  
  void damp(){
    
    PVector normalisedvelocity = velocity.copy().normalize();
    PVector dampAmount = PVector.mult( normalisedvelocity,-25 / mass); // it 25 pixels per second per second
    addForce(dampAmount);
  }
  
  void setTranslation()
  {
    this.setTransformAbs(position, 1, 0, 0, 0);
  }
}
