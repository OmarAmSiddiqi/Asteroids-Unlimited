class Ship
{
 PVector position;
 PVector velocity;
 PVector acceleration;
 PVector rotation;
 float drag = .9;
 float r = 15;
 PImage img = loadImage("rocket.png");
 int shipHealth;
 int oldShipHealth;
 PVector dist;
 Asteroid asteroids;

 public Ship(int h)
 {
  position = new PVector(width/2, height-50);
  acceleration = new PVector(0,0);
  velocity = new PVector(0,0);
  rotation = new PVector(0,1);
  shipHealth = h;
 } 
 
 void update()
 {
   PVector below = new PVector(0, -2*r);
   rotate2D(below, heading2D(rotation)+PI/2);
   below.add(position);

   velocity.add(acceleration);
   velocity.mult(drag);//adjust the speed to avoid it moving too fast
   velocity.limit(5);//the maximum speed is 5
   position.add(velocity);

 }
 
 void roundBack()
 {
    if (position.x < r)
      position.x = width-r;
    
    if (position.y < r) 
      position.y = height-r;
    
    if (position.x > width-r) 
      position.x = r;
    
    if (position.y > height-r)
      position.y = r;    
 }
 
 boolean checkCollision(ArrayList<Asteroid> asteroids) // check in ship crashed into any asteroids
 {
   for(Asteroid a : asteroids) // check every single asteroid object on screen
   {
      PVector dist = PVector.sub(a.position, position);
      this.dist = dist; 
      
      this.asteroids = a;
   
      if(dist.mag() < a.radius + r/2) // if ship hit asteroid
      {
         println("ship hit asteroid");
         a.hit(asteroids);
         oldShipHealth = this.shipHealth; // record ship health before health damage is taken
         dgdbObject.setDGDBvar("Health", ship.shipHealth); // record the ship health into dgdb object
         dgdbObject.adjustGameHardness("Health"); // finally adjust the ship health using the dgdb object
         fileCrash.play(1, 0.25); // play crash sound at 25% volumn
         
         return true; 
      }
   }
   return false;
 }
 
 
 public void renderHealthDiff()
 {
   if(shipCrash == true)
   {
     textSize(32);
     textAlign(LEFT);
     fill(0, 255, 0);
     text((ship.shipHealth - ship.oldShipHealth)*2, (width/4)*2 + 130, (height/15 + 25) + healthDamageAnimation);
     healthDamageAnimation = healthDamageAnimation + 1;
     
     if(healthDamageAnimation == 20)
     {
       healthDamageAnimation = 0;
       shipCrash = false;
     }
   }
 }
 
 //public void renderEnemiesAdded()
 //{
 //  if(enemiesAdded == true)
 //  {
 //    textSize(32);
 //    textAlign(LEFT);
 //    fill(0, 255, 0);
 //    text("+" + (enemiesAddedQty), 100 + enemiesAddedAnimation, height-20);
 //    enemiesAddedAnimation = enemiesAddedAnimation + 1;
     
 //    if(enemiesAddedAnimation == 20)
 //    {
 //      enemiesAddedAnimation = 0;
 //      enemiesAdded = false;
 //    }
 //  }
 //}
 
 void render()
 { 
   roundBack();
   
   float theta = heading2D(rotation)  + PI/2;
   theta += PI;
   
   pushMatrix();
   translate(position.x, position.y);
   rotate(theta);
   fill(0);

   image(img,-r,-r*1.5,2*r,3*r);
   popMatrix();
 }
 
 /*float heading2D(PVector pvect)
 {
   return (float)(Math.atan2(pvect.y, pvect.x));  
 }*/
 
/* void rotate2D(PVector v, float theta) 
 {
    float xTemp = v.x;
    v.x = v.x*cos(theta) - v.y*sin(theta);
    v.y = xTemp*sin(theta) + v.y*cos(theta);
 }*/
 
}
