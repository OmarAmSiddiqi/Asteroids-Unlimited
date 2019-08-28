class Asteroid
{
 float radius;
 float omegaLimit = .05;
 PVector position;
 PVector velocity;
 PVector rotation;
 float spin;
 int col = 100;
 PImage asteroidPic;
 int asteroidHealth;
 int asteroidWorth;
 
 public Asteroid(PVector pos, float radius_, PImage pics_, int h)
 {
   radius  = radius_;

   position = pos;
   float angle = random(2 * PI);
   velocity = new PVector(cos(angle), sin(angle));
   velocity.mult((50*50)/(radius*radius));
 
   angle = random(2 * PI);
   rotation = new PVector(cos(angle), sin(angle));
   spin = random(-5,5);
   asteroidPic = pics_;  
   
   asteroidHealth = h;
   
   this.asteroidWorth = dgdbObject.adjustAsteroidWorth();  // new asteroid worth

 }
 
 void hit(ArrayList<Asteroid> asteroids) // if anything hits an asteroids
 {
   asteroidHealth = asteroidHealth - 10; // decrease asteroid health by 10
   
   if (asteroidHealth <= 0 ) // if asteroid health is zero
   {
     asteroids.remove(this); // remove object
     dgdbObject.setDGDBvar("Enemy", -1); // record -1 in dgdb object // see line 273 in main class
   }
   
   if(!(ship.dist.mag() < ship.asteroids.radius + ship.r/2)) // if anything else besides the ship crashes into asteroids (LIKE BULLET OBJECTS).
   {                                                         // NOTICE ! NEGATE BOOLEAN
     gameScore += this.asteroidWorth;                        // increase score by asteroids worth
     
     dgdbObject.setDGDBvar("Asteroid Worth", asteroidWorth); // record asteroid worth into dgdb object

     fileExplosion.play(); // play explosion sound
   }
 }

 
 //update the asteroid's position and make it spin
 void update()
 {
   position.add(velocity);
   rotate2D(rotation, radians(spin));
 }
 
 //display the asteroid
 void render()
 {
   roundBack();
   pushMatrix();
   translate(position.x,position.y);
   rotate(heading2D(rotation)+PI/2);
   image(asteroidPic, -radius,-radius,radius*2, radius*2);
   popMatrix();
 }
 
 void roundBack()
 {
    if (position.x < 0)
      position.x = width;
    
    if (position.y < 0) 
      position.y = height;
    
    if (position.x > width) 
      position.x = 0;
    
    if (position.y > height)
      position.y = 0;     
 }   


/* 
  float heading2D(PVector pvect)
 {
   return (float)(Math.atan2(pvect.y, pvect.x));  
 }

 void rotate2D(PVector v, float theta) 
 {
   float xTemp = v.x;
   v.x = v.x*cos(theta) - v.y*sin(theta);
   v.y = xTemp*sin(theta) + v.y*cos(theta);
 }//*/
 
}
