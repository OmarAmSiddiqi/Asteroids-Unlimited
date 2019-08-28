class DGDB // asteroid will move faster with more time
{
  // score, health, time, enemies killed
  
  public float score, health, time, enemiesKilled, bullets;
  int asteroidWorth;
  public final String scoreIndex = "Score", healthIndex = "Health", timeIndex = "Time", enemiesKilledIndex = "Enemy";
  public final String bulletInex = "Bullets", asteroidWorthIndex = "asteroidWorth";
  public final float lowScore = 100, medScore = 500, highScore = 900;
  public int timeWastedCounter4Score, scoreAnimation = 0;
  final int everySomethingSeconds = 10;
  public int numOfCurrentEnemies;
  
  int oldScore;
  
  void DGDB()
  {
    this.score = 0; this.health = 0; this.time = second(); this.enemiesKilled = 0; this.timeWastedCounter4Score = second();
    this.numOfCurrentEnemies = 0;
    this.asteroidWorth = 0; this.bullets = 0;
  }

  void setDGDBvar(String string, float number)
  {
    if(string == "Score")
    {
      this.score = number; // record the score into the dgdb object
      gameScore = this.score; // send the sore back to the global var gameScore in the asteroidsGame main class
    }
    else if(string == "Health")
    {
      this.health = number;
    }
    else if(string == "Time")
    {
      this.time = number;
    }
    else if(string == "Enemy")
    {
      this.numOfCurrentEnemies = int(this.numOfCurrentEnemies + number);
      if (this.numOfCurrentEnemies == 5)
      {
        println("We have " + this.numOfCurrentEnemies + " enemies left");
      }
    }
    else if(string == "Bullets")
    {
      this.bullets = number;
    }
    else if(string == "Asteroid Worth")
    {
      this.asteroidWorth = int(number);
    }
    else
    {
      println("ERROR: Incorrect variables passed in DGDB constructor");
    }
  }
  
  float getScore()
  {
    return this.score;
  }
  
  void adjustGameHardness(String string)
  {
    if(string == "Score")
    {
      this.adjustScore();
    }
    else if(string == "Health")
    {
      this.adjustHealthDamage();
    }
    else if(string == "Time") // not being used currently
    {
      
    }
    else if(string == "Enemy") // not being used currently
    {
      
    }
    else if(string == "Bullets")
    {
      this.adjustBulletsMax();
    }
    else if(string == "Asteroid Worth") // not being used currently
    {
    
    }
    else
    {
      println("ERROR: Incorrect variables passed in DGDB");
    }
  }
  
  void adjustHealthDamage()
  {
    if(this.score >= highScore) // 900
    {
      int oldShipHealth = ship.shipHealth;
      ship.shipHealth -= 10; // 20
      println("Health Damage " + (oldShipHealth - ship.shipHealth));
    }
    else if (this.score >= medScore) // 500
    {
      int oldShipHealth = ship.shipHealth;
      ship.shipHealth -= 5; // 10
      println("Health Damage " + (oldShipHealth - ship.shipHealth));
    }
    else if (this.score >= lowScore) // 100
    {
      int oldShipHealth = ship.shipHealth;
      ship.shipHealth -= 4; // 8
      println("Health Damage " + (oldShipHealth - ship.shipHealth));
    }
    else // less than 100
    {
      int oldShipHealth = ship.shipHealth;
      ship.shipHealth -= 1;
      println("Health Damage " + (oldShipHealth - ship.shipHealth));
    }
  }
  
  void adjustScore()
  {
    this.timeWastedCounter4Score = int(this.time);
    
    if((this.timeWastedCounter4Score)%10 == 0 && frameCount%24 == 0) // for both every 10 seconds and every 24 frames
    {
      this.oldScore = int(this.score); // record the score into oldScore
      this.score = this.score * 0.9; // reduce score by 10 percent
      println("score cut down to " + int(this.score)); // println
      
      timeWastedCounter4Score = 0; // reset the counter to 0
      scoreAnimation = 0; // reset the animation variable (used to move the text in the y axis)
    }
    
    if((this.timeWastedCounter4Score)%10 == 0)// every 10 seconds only
    {
      int scoreDiff = 0; // initialize the scoreDiff to 0
      scoreDiff = int(this.score) - oldScore; // hold the difference between old score and new score (deducted score by 10 percent before)
      
      textSize(32);
      textAlign(LEFT);
      fill(0, 255, 0); // green color text
      text(scoreDiff, 110, (height/15 + 25) + scoreAnimation); // moving the scoreDiff in the y axis
      scoreAnimation += 1; // moving the scoreDiff in the y axis
    }
  }
  
  void adjustBulletsMax()
  {
      if(this.score >= highScore) // 900
      {
        maxBullets = 6;
      }
      else if (this.score >= medScore) // 500
      {
        maxBullets = 8;
      }
      else if (this.score >= lowScore) // 100
      {
        maxBullets = 10;
      }
      else // less than 100
      {
        maxBullets = 15;
      }
  }
  
  int adjustAsteroidWorth()
  {
    if(dgdbObject.score >= dgdbObject.highScore) // 900
    {
      this.asteroidWorth = 8;
      println("Asteroids are now worth: " + this.asteroidWorth);
      return this.asteroidWorth;
    }
    else if (dgdbObject.score >= dgdbObject.medScore) // 500
    {
      this.asteroidWorth = 10;
      println("Asteroids are now worth: " + this.asteroidWorth);
      return this.asteroidWorth;
    }
    else if (dgdbObject.score >= dgdbObject.lowScore) // 100
    {
      this.asteroidWorth = 12;
      println("Asteroids are now worth: " + this.asteroidWorth);
      return this.asteroidWorth;
    }
    else // less than 100
    {
      this.asteroidWorth = 14;
      println("Asteroids are now worth: " + this.asteroidWorth);
      return this.asteroidWorth;
    }
  }

  int spawnMoreEnemies()
  {
    if(this.score >= highScore) // || time wasted
    {
      enemiesAddedQty = int(random(15, 20));
      return enemiesAddedQty;
    }
    else if (this.score >= medScore)
    {
      enemiesAddedQty = int(random(10, 14));
      return enemiesAddedQty;
    }
    else if (this.score >= lowScore)
    {
      enemiesAddedQty = int(random(6, 9));
      return enemiesAddedQty;
    }
    else
    {
      enemiesAddedQty = int(random(0, 5));
      return enemiesAddedQty;
    }
  }
  
  public void renderEnemiesAdded()
  {
    if(enemiesAdded == true)
    {
      textSize(32);
      textAlign(LEFT);
      fill(0, 255, 0);
      text("+" + (enemiesAddedQty), 100 + enemiesAddedAnimation, height-20);
      enemiesAddedAnimation = enemiesAddedAnimation + 1;
      
      if(enemiesAddedAnimation == 20)
      {
        enemiesAddedAnimation = 0;
        enemiesAdded = false;
      }
    }
  }
  
  
} // END OF DGDB CLASS
