import processing.sound.*;
public SoundFile file;
public SoundFile fileFire;
public SoundFile fileCrash;
public SoundFile fileExplosion;

public Ship ship;
public DGDB dgdbObject;

public int healthDamageAnimation = 0;
public boolean shipCrash;
public int enemiesAddedAnimation = 0;
public boolean enemiesAdded;
public int enemiesAddedQty;

boolean upPressed = false;//CHANGE LEFT AND RIGHT TO UP AND DOWN( IN SHIP TOO)
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;

float shipSpeed = 4;
float bulletSpeed = 10;

int numAsteroids = 10; //the number of asteroids
int startingRadius = 30; //the size of an asteroid
public int maxBullets = 15;

PImage asteroidPic;
PImage rocket;
PImage bulletPic;

ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;

PFont font;

// game state variables
int gameState;
public final int INTRO = 1;
public final int PLAY = 2;
public final int PAUSE = 3;
public final int GAMEOVER = 4; //
public final int WIN = 5; //
public final int CRED = 6;

public float gameScore; // to hold the score
public float maxScore = 1500;
public int liveGameTime = second(); // to hold the time passed

int everySomethingSeconds = second();
int bulletCounter = second();

public int musicTimer = second();
public int bulletTimer = second();

void setup()
{
    background(0);
    size(800,500);
    font = createFont("Cambria", 32); 
    frameRate(24);
    file = new SoundFile(this, "music.wav");
    fileFire = new SoundFile(this, "fire.wav");
    fileCrash = new SoundFile(this, "crash.wav");
    fileExplosion = new SoundFile(this, "explosion.wav");
    
    everySomethingSeconds = 4;
    bulletCounter = 0;
    
    asteroidPic = loadImage("asteroid.png");
    rocket = loadImage("rocket.png");
    bulletPic = loadImage("bullet.png");
 
    asteroids = new ArrayList<Asteroid>(0);
 
    gameState = INTRO;
 
    musicTimer = 0;
    gameScore = 0;
    liveGameTime = 0;
 
    file = new SoundFile(this, "music.wav");
}


void draw()
{  
    switch(gameState) 
    {
        case INTRO:
          drawScreen("Welcome!", "Press s to start");
          if((frameCount)%165 == 0 || frameCount == 24)
            file.play();
        break;
        
        case PAUSE:
          drawScreen("PAUSED", "Press p to resume");
        break;
    
        case CRED:
          drawScreen("PAUSED to see credits", "Press c to resume");
          drawCredits();
        break;
    
        case GAMEOVER:
          drawScreen("GAME OVER", "Press s to try again");
        break;
    
        case WIN:
          drawScreen("YOU WIN", "Press s to try again");
        break;
    
        case PLAY:
        background(0);
      
        if((frameCount)%165 == 0)
        file.play();
      
        ship.update();
        ship.render(); 
      
        if(ship.checkCollision(asteroids) && ship.shipHealth <= 0)
        {
            gameState = GAMEOVER;
            liveGameTime = 0;
            gameScore = 0;
        }
        else if((gameScore >= maxScore)) // s/24 <= 30 && 
        {
          
          //spawn more
          gameState = WIN;
          liveGameTime = 0;
          gameScore = 0;
        }
        else if(asteroids.size() <= 5)
        { 
          spawnAsteroids(dgdbObject.spawnMoreEnemies());
          //enemiesAddedQty = dgdbObject.spawnMoreEnemies();
          println("Spawning " + enemiesAddedQty + " more enemies");
          println("We have a total of " + (enemiesAddedQty + 5) + " enemies");
          enemiesAdded = true;
        }
        else
        {
            for(int i = 0; i < bullets.size(); i++)
            {    
              bullets.get(i).update();
              bullets.get(i).render();
              
              if(frameCount%24 == 0)
                  bullets.get(i).bulletRunTime += 1;
    
              if(bullets.get(i).checkCollision(asteroids) || bullets.get(i).bulletRunTime == bullets.get(i).bulletMaxLife)
              {
                bullets.get(i).bulletRunTime = 0;
                bullets.remove(i);
                
                i--;
                
                if(bulletCounter%everySomethingSeconds == 0)// && frameRate%24 == 0)
                {
                 maxBullets++;
                }
              }
            }
        
            for(int i=0; i<asteroids.size(); i++)//(Asteroid a : asteroids)
            {
              asteroids.get(i).update();            
              asteroids.get(i).render(); 
            }
          
            float theta = heading2D(ship.rotation)+PI/2;    
             
            if(leftPressed)
              rotate2D(ship.rotation,-radians(5));
        
            if(rightPressed)
              rotate2D(ship.rotation, radians(5));
            
            if(upPressed)
            {
              ship.acceleration = new PVector(0,shipSpeed); 
              rotate2D(ship.acceleration, theta);
            }
         
            if(downPressed)
            {
              ship.acceleration = new PVector(0,-shipSpeed);
              rotate2D(ship.acceleration, theta);
            }
         }
         
         textSize(32);
         textAlign(LEFT);
         fill(0, 255, 0);
         text(maxBullets + ":", (width/4)*3 - 35, height-20); // print the number of currently avaliable bullets (int)
         for(int i = 1; i <= maxBullets; i++) // for every bullet avaliable, draw a new image side by side (bottom right corner)
         {
           image(bulletPic, (width/4)*3 + (i*10), height - 50, 20, 40); // (i*10) is how the bullet images are spaced
         //image(bulletPic, (      X VALUE     ), (Y VALUE  ), image size x, image size y);
         }
         dgdbObject.setDGDBvar("Bullets", maxBullets); // record how many bullets are avaliable
         
         bulletCounter = liveGameTime; // base bullet counter off live game time (int)
         
         if(bulletCounter%5 == 0)// every 5 seconds reload ammo
         {
           dgdbObject.adjustGameHardness("Bullets"); // adjust the gameHardness for bullets
           bulletCounter = 0;
         }
         
         textSize(32);
         textAlign(LEFT);
         fill(0, 255, 0);
         text("     :" + dgdbObject.numOfCurrentEnemies, 5, height-20);
         image(asteroidPic, 3, height-60, startingRadius*2, startingRadius*2);
         
         textSize(32);
         textAlign(LEFT);
         fill(0, 255, 0);
         text("Score: " + int(dgdbObject.score), 5, height/15);
         
         textSize(32);
         textAlign(LEFT);
         fill(0, 255, 0);
         text("Timer: " + liveGameTime, (width/4) + 15, height/15);
       
         textSize(32);
         textAlign(LEFT);
         fill(0, 255, 0);
         text("Health: " + ship.shipHealth, (width/4)*2 + 10, height/15);
       
         fill(0, 255, 0);
         rect((width/4)*3, height/15 - 25, ship.shipHealth, 25);
       
       //=================================TIME=======================================
         if (frameCount%24 == 0)
             liveGameTime = liveGameTime + 1; // every second, increment time by 1
             
         dgdbObject.setDGDBvar("Time", liveGameTime); // record the time into the dgdb object
       //=============================================================================
         
         dgdbObject.setDGDBvar("Score", gameScore); // record score into dgdb object
         dgdbObject.adjustGameHardness("Score"); // adjust score dynamically
         gameScore = dgdbObject.getScore(); // gamescore is now adjusted to new score
         
         renderHealthDamageAnim(); // draw the health damage animation
             
         frameRate(24);
         break; // switch statement break for PLAY case (Game mode "PLAY")
    } // END OF SWITCH STATEMENT
} // END OF DRAW LOOP

//Initialize the game settings. Create ship, bullets, and asteroids
void initializeGame() 
{
   ship  = new Ship(100);
   dgdbObject = new DGDB();
   bullets = new ArrayList<Bullet>();   
   asteroids = new ArrayList<Asteroid>();
   spawnAsteroids(numAsteroids);  
}

void spawnAsteroids(int _numAsteroids)
{
  for(int i = 0; i <_numAsteroids; i++)
   {
      PVector position = new PVector((int)(Math.random()*width), 50);      
      asteroids.add(new Asteroid(position, startingRadius, asteroidPic, 20));
      
      dgdbObject.setDGDBvar("Enemy", 1);
   }
}

void renderHealthDamageAnim()
{
  if(ship.dist.mag() < ship.asteroids.radius + ship.r/2)
  {
    shipCrash = true;
  }
  ship.renderHealthDiff();
  dgdbObject.renderEnemiesAdded();
}

//Fire bullets
void fireBullet()
{ 
  //println("fire"); //this line is for debugging purpose
  fileFire.play(1, 0.25);
  PVector pos = new PVector(0, ship.r*2);
  rotate2D(pos,heading2D(ship.rotation) + PI/2);
  pos.add(ship.position);
  PVector vel  = new PVector(0, bulletSpeed);
  rotate2D(vel, heading2D(ship.rotation) + PI/2);
  bullets.add(new Bullet(pos, vel));
}

void keyPressed()
{ 
    if(key== 's' && ( gameState==INTRO || gameState==GAMEOVER || gameState==WIN)) 
    {
      initializeGame();  
      gameState=PLAY;    
    }
  
    if(key=='p' && gameState==PLAY)
      gameState=PAUSE;
    else if(key=='p' && gameState==PAUSE)
      gameState=PLAY;
    if(key=='c' && gameState==PLAY)
      gameState=CRED;
    else if(key=='c' && gameState==CRED)
      gameState=PLAY;
    
    // when x key is pressed, fire a bullet
    if(key == 'x' && gameState == PLAY && maxBullets <= 15 && maxBullets > 0)
      {
      fireBullet();
      maxBullets--;
      }
   
    if(key==CODED && gameState == PLAY)
    {         
      if(keyCode==UP) 
        upPressed=true;
      else if(keyCode==DOWN)
        downPressed=true;
      else if(keyCode == LEFT)
        leftPressed = true;  
      else if(keyCode==RIGHT)
        rightPressed = true;        
    }
}

void keyReleased() // when a key is released
{
  try{
    if(key==CODED)
    {
      if(keyCode==UP)
      {
        upPressed=false;
        ship.acceleration = new PVector(0,0);  
      } 
      else if(keyCode==DOWN)
      {
        downPressed=false;
        ship.acceleration = new PVector(0,0); 
      } 
   
      else if(keyCode==LEFT)
        leftPressed = false; 
      else if(keyCode==RIGHT)
        rightPressed = false;           
    } 
  }
  catch (Exception e)
  {
    println("Can't move ship yet!");
  }
}

void drawScreen(String title, String instructions) 
{
  
  background(0,0,0);
  
  // draw title
  fill(255,100,0);
  textSize(60);
  textAlign(CENTER, BOTTOM);
  text(title, width/2, height/2);
  
  // draw instructions
  fill(255,255,255);
  textSize(32);
  textAlign(CENTER, TOP);
  text(instructions, width/2, height/2);
}


float heading2D(PVector pvect)
{
   return (float)(Math.atan2(pvect.y, pvect.x));  
}


void rotate2D(PVector v, float theta)
{
  float xTemp = v.x;
  v.x = v.x*cos(theta) - v.y*sin(theta);
  v.y = xTemp*sin(theta) + v.y*cos(theta);
}

void drawCredits()
{
  background(0, 100, 0);
  textAlign(CENTER);
  text("Asteroids Unlimited \n" + 
  "Programmer: Ling Xu \n" +
  "Game Hardness Algorithm: Abdurrahman Siddiqi \n" +
  "Background Animation: Ling Xu \n" +
  "Background Music: Asteriod - Wavy Beat 1 \n" +
  "Thank You for playing!",
  width/2, height/2-60);
}
