abstract class SimMovable extends SimTransform
{
  PVector velocity = new PVector(0,0,0);
  PVector acceleration = new PVector(0,0,0);
  float mass = 1.0f;
  
  abstract boolean collidesWith(SimTransform c);
  
  abstract boolean calcRayIntersection(SimRay sr);
  
  abstract void drawMe();
  
  void moveMe()
  {
    this.position.add(this.velocity);
    this.velocity.add(this.acceleration);
    
    print("\npos: " + this.position + " vel: " + this.velocity);
    
    this.acceleration = vec(0,0,0);
  } 
  
  void applyForce(PVector force)
  {
    // F = ma
    // a = F/m
    this.acceleration.add(force.div(this.mass));    
  }
  
  void setVelocity(PVector v)
  {
    this.velocity = v;
  }
  
  void setAcceleration(PVector a)
  {
    this.acceleration = a;
  }

}

class MovableSphere extends SimMovable
{
  
}
