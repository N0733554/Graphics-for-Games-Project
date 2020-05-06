class MovableSphere extends SimSphere
{
  float mass = 1.0;
  float minDampAmount = 1.0;
  float gravityStrength = 100f;
  
  PVector position = new PVector(0,0,0);
  PVector velocity = new PVector(0,0,0);
  PVector direction = new PVector(0,0,0);
  PVector force = new PVector(0,0,0);
  PVector acceleration = new PVector(0,0,0);
  
  PVector prevPos = new PVector(0,0,0);
  
  float colliderSize = 7;  
  BoundingBox collider = new BoundingBox(colliderSize);
  
  public void setMass(float m){    
    this.setRadius(m);
    mass = m;
  }
  
  public void setPosition(float x, float y, float z){    
    position = vec(x,y,z);
    this.setTransformAbs(position, 1, 0,0,0);
  }

  public void moveMe(float delta, SimSurfaceMesh terrain) {
    // assume a number of forces have beed added by the system
    damp();
    calculateAcceleration(delta);
    
    velocity.add( acceleration );
    position.add( PVector.mult(velocity,delta) );
    setTranslation();
    
    direction = velocity.copy();
    direction.normalize();
    
    collider.Update(position, terrain);
    
    calcCollisions();
    //println("position: ", position.y);
    prevPos = position.copy();
    
    resetForceAndAcceleration();
  } 
  
  public void addForce(PVector f){
    force.add(f);
  }
  
  public void applyGravity()
  {
    addForce(vec(0,gravityStrength,0));
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
    if(velocity.mag() > minDampAmount)
    {
      PVector normalisedvelocity = velocity.copy().normalize();
      PVector dampAmount = PVector.mult( normalisedvelocity,-25 / mass); // it 25 pixels per second per second
      addForce(dampAmount);
    }
  }
  
  void setTranslation()
  {
    this.setTransformAbs(position, 1, 0, 0, 0);
  }
  
  //old
  /*void calcCollisions(SimSurfaceMesh t)
  {
    SimRay ballray = new SimRay( position, PVector.add(this.position, this.velocity));
    
    if( ballray.calcIntersection(t)){
      printRayIntersectionDetails("terrain", ballray);
      
      PVector intersectPt = ballray.getIntersectionPoint();
      PVector intersectNormal = ballray.getIntersectionNormal();
      
      if( this.isPointInside( intersectPt ) ) {
        println("hitting");
        
        float speed = velocity.mag();
        
        velocity = PVector.mult(reflectOffSurface(direction, intersectNormal), speed);
        println("direction: ", direction);
      }
    }
  }*/
  
  void calcCollisions()
  {
    float shortestDist = 10000;
    PVector closestPoint = new PVector(0,0,0);
    PVector intersectNrml = new PVector(0,0,0);
    
    //println("numRays: ", collider.containedVertices.size());
    
    /*for( PVector point : collider.containedVertices) // Iterating through all nearby terrain vertices
    {
      PVector rayDirection = PVector.sub(point.copy(), position.copy());
      //rayDirection.normalize();
      println("position: ", position, " point: ", point, " rayDirection: ", rayDirection);
      
      //SimRay newRay = new SimRay(position, point);  // Creating array from ball to terrain vertex  
      
      SimRay newRay = new SimRay( this.getOrigin(), PVector.add(this.getOrigin(), rayDirection));
      
      rayList.add(newRay);  // Add ray to the list of rays
    }*/
    
    for( SimTriangle t : collider.containedTriangles )
    {
      float distanceToTriangle = dist(position.x, position.y, position.z,t.getCenter().x,t.getCenter().y,t.getCenter().z);
      if(distanceToTriangle < shortestDist)
      {
        shortestDist = distanceToTriangle;
        closestPoint = t.getCenter();
        intersectNrml = t.surfaceNormal();
      }
    }
    
    if( this.isPointInside(closestPoint) )
    {
      //println("colliding at: ", closestPoint);
      Bounce(intersectNrml);
    }
  }
  
  void Bounce(PVector norm)
  {
    //println("hitting");
    setPosition(prevPos.x,prevPos.y,prevPos.z);
    float speed = velocity.mag();
        
    
        
    velocity = PVector.mult(reflectOffSurface(direction, norm), speed);
    //println("direction: ", direction, " normal: ", norm);
  }
  
  // Taken from SimObjects_3D_Bounce
  
  PVector reflectOffSurface(PVector incident, PVector surfaceNormal){
  // Using Fermat's Principle: the formula R = 2(N.I)N-I, where N is the surface normal,
  // I is the vector of the incident ray, and R is the resultant reflection.
  // First make sure you are working on copies only so changes are not propagated outside the method,
  // and that the incident and surfaceNormal vectors are normalized
  PVector i = incident.copy();
  i.normalize();
  
  PVector n = surfaceNormal.copy();
  n.normalize();
  
  // do the vector maths
  float n_dot_i_x2 = n.dot(i)*2;
  
  PVector n_dot_i_x2_xn = PVector.mult(n, n_dot_i_x2);
  
  PVector reflection =  PVector.sub(n_dot_i_x2_xn,i);
   
  // the above formula gives true refelction. I.e. the vector
  // travelling TOWARDS the reflection point on the surface FROM the refected direction.
  // We want the vector travelling AWAY from the reflection point, so we need to 
  // invert the reflection vector
  return reflection.mult(-1);
  
}

void printRayIntersectionDetails(String what, SimRay sr){
          println("ray has hit " + what);
          PVector intersectionPt = sr.getIntersectionPoint();
          PVector intersectionNormal = sr.getIntersectionNormal();
          float distanceToIntersection = intersectionPt.dist(sr.getOrigin());
          println("Intersection at ", intersectionPt, " distance = ", distanceToIntersection);
          
          println("Surface Normal at ", intersectionNormal);
          println("ID of object hit ", sr.getColliderID());
          println();
}
  
}

class BoundingBox extends SimBox{
  
  //public PVector[] containedVertices;
  public ArrayList<PVector> containedVertices;
  SimTriangle[] allTriangles = terrain.getTriangles();
  public ArrayList<SimTriangle> containedTriangles;
  float size;
  
  BoundingBox(float s)
  {
    size = s;
  }
  
  public void Update(PVector pos, SimSurfaceMesh terrain)
  {
    updateLocation(pos);
    
    containedVertices = new ArrayList<PVector>();
    containedTriangles = new ArrayList<SimTriangle>();
    
    /*
    for (PVector p : terrain.meshVertices)
    {
      if(this.isPointInside(p))
      {
        containedVertices.add(p);
      }
    }
    */
    
    for(SimTriangle t : allTriangles)
    {
      if(isPointInside(t.getCenter()))
      {
        containedTriangles.add(t);
        strokeWeight(1);
        stroke(255,0,0);
        //line(getOrigin().x,getOrigin().y,getOrigin().z,t.getCenter().x,t.getCenter().y,t.getCenter().z);
      }
    }
    //println("contained: ",containedTriangles.size());
    //noFill();
    //drawMe();
  }
  
  void updateLocation(PVector pos)
  {
    setTransformAbs(pos, size, 0,0,0);
  }
}
