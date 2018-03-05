/*******************************************************************************
 * Videogame Project                  // Date: February 27, 2018
 * ARTG 2260: Programming Basics      // Instructor: Jose
 * Written By: Richard Tu             // Email: tu.r@husky.neu.edu
 * Title: Castle Defenders
 * Description: A game where you play as a hero with special abilities and build
 *              a defense that will withstand the zombie invasion!
 *              -Protect your villagers! They pay you taxes!
 *              -Knight:
 *                      Left Click - semi circle slash for 75 dmg - cost 10 energy
 *                      <Hold> Left Click - 30 dmg sword at no cost
 *                      Right Click - full circle slash for 150 dmg - cost 20 energy
 *                      <Hold> Right Click - Shield - cost .2 energy per frame (approx 12 energy per second)
 *              -Ranger:
 *                      Left Click - Shoots one arrow - cost one arrow
 *                      <Hold> Left Click - Shoots one large arrow piercing through enemies - cost 10 arrows
 *                      Right Click - Shoots fan of 5 arrows - cost 10 arrows
 *                      <Hold> Right Click - Shoots more arrows longer held down - cost x arrows or all arrows
 *              -Mage: <Coming Soon>
 ******************************************************************************/

PImage groundTile;
PImage grassTile;
PImage wall;
PImage rangerLoaded;
PImage arrow;
PImage knightLoaded;
PImage mageLoaded;
PImage randomLoaded;
PImage crystalSprite;
PImage sword;
PImage bow;
PImage staff;
PImage goldBag;
PImage wrench;

color gray;

int floorSize = 150;
int grassSize = 300;
int shootFrame;
int fanFrame;
int slashFrame;
int shieldFrame;
int stopShieldFrame = -1;
int score;
int scoreSize;
int panelHeight;
int panelWidth;
int gridWidth;
int gridHeight;
int frameCountSpawn;

float slashRadius;
float slashSize;
float holdSlashSize;
float holdSlashAngle;
float spawn;

boolean playerMovingUp = false;
boolean playerMovingLeft = false;
boolean playerMovingRight = false;
boolean playerMovingDown = false;
boolean shootArrow = false;
boolean fanArrow = false;
boolean slashSword = false;
boolean holdSlashSword = false;
boolean slashSwordCircle = false;
boolean shielding = false;
boolean autoSwordSlash = false;
boolean selectionScreen = true;
boolean gameOver = false;

Player player;
Ranger ranger;
Knight knight;
Crystal crystal;
ArrayList<Enemy> enemies;
ArrayList<Enemy> decayEnemies;
ArrayList<Integer> removeEnemies;
ArrayList<Arrow> arrows;
ArrayList<Spawner> spawners;
ArrayList<ArrayList<Tower>> grid;
ArrayList<Villager> villagers;
Enemy zombie;

void setup() {
  //settings
  //size(1024, 1024);
  fullScreen(P2D);
  colorMode(HSB, 360);
  panelHeight = height / 10;
  background(gray); //background grey
  groundTile = loadImage("/sprites/GroundTile.jpg");
  grassTile = loadImage("/sprites/Grass3.png");
  rangerLoaded = loadImage("/sprites/Ranger2-1.png");
  arrow = loadImage("/sprites/ArrowCrop3.png");
  knightLoaded = loadImage("/sprites/Knight2-1.png");
  mageLoaded = loadImage("/sprites/Mage3-1.png");
  randomLoaded = loadImage("/sprites/Random.png");
  crystalSprite = loadImage("/sprites/Crystal.png");
  sword = loadImage("/sprites/Sword.png");
  bow = loadImage("/sprites/Bow.png");
  staff = loadImage("/sprites/Staff.png");
  wall = loadImage("/sprites/CastleWall.png");
  goldBag = loadImage("/sprites/GoldBag.png");
  wrench = loadImage("/sprites/wrench.png");
  //run a single time  
  gridWidth = width/64;
  gridHeight = (height - panelHeight)/64;
  grid = new ArrayList<ArrayList<Tower>>();
  for (int i = 0; i < gridHeight + 1; i++) {
    grid.add(new ArrayList<Tower>());
    for (int j = 0; j < gridWidth + 1; j++) {
      grid.get(i).add(null);
    }
  }
  ranger = new Ranger();
  knight = new Knight();
  player = knight;
  crystal = new Crystal(10000);
  enemies = new ArrayList<Enemy>();
  decayEnemies = new ArrayList<Enemy>();
  removeEnemies = new ArrayList<Integer>();
  arrows = new ArrayList<Arrow>();
  spawners = new ArrayList<Spawner>();
  for (int i = 0; i < 10; i++) {
    spawners.add(new Spawner(5000, 100));
  }
  villagers = new ArrayList<Villager>();
}

void chooseCharacter() {
  drawFloor();
  drawPanel();
  rectMode(CENTER);
  imageMode(CENTER);
  stroke(0);
  strokeWeight(10);
  if (player.equals(knight)) {
    fill(360, 360, 360, 120);
    tint(255, 126);
  } else {
    fill(360, 360, 360, 270);
  }
  rect(width/5, height/2, width/5, height/1.5);
  image(knightLoaded, width/5, height/2, width/5, width/5);
  noTint();
  if (player.equals(ranger)) {
    fill(120, 360, 360, 120);
    tint(255, 126);
  } else {
    fill(120, 360, 360, 270);
  }
  rect(2*width/5, height/2, width/5, height/1.5);
  image(rangerLoaded, 2*width/5, height/2, width/5, width/5);
  noTint();
  fill(240, 360, 360, 270);
  rect(3*width/5, height/2, width/5, height/1.5);
  fill(240, 0, 360, 270);
  rect(4*width/5, height/2, width/5, height/1.5);
  image(mageLoaded, 3*width/5, height/2, width/5, width/5);
  image(randomLoaded, 4*width/5, height/2, width/5, width/5);
  rectMode(CORNER);
  imageMode(CORNER);
  
  textAlign(CENTER);
  textSize(150);
  fill(360, 360, 360);
  text("Hit <Enter> to Select", width/2, height/8);
  textAlign(LEFT);
}

void reinitializeGame() {
  gameOver = false;
  selectionScreen = true;
  enemies = new ArrayList<Enemy>();
  decayEnemies = new ArrayList<Enemy>();
  removeEnemies = new ArrayList<Integer>();
  arrows = new ArrayList<Arrow>();
  spawners = new ArrayList<Spawner>();
  villagers = new ArrayList<Villager>();
  for (int i = 0; i < 20; i++) {
    spawners.add(new Spawner(5000, 100));
  }
  score = 0;
  knight = new Knight();
  ranger = new Ranger();
  player = knight;
  crystal = new Crystal(10000);
  grid.clear();
  for (int i = 0; i < gridHeight + 1; i++) {
    grid.add(new ArrayList<Tower>());
    for (int j = 0; j < gridWidth + 1; j++) {
      grid.get(i).add(null);
    }
  }
}

void drawPanel() {
  fill(0, 0, 120);
  stroke(0, 0, 0);
  strokeWeight(5);
  rect(0, height - panelHeight, width, panelHeight);
  image(crystalSprite, 10, height - panelHeight + 10, panelHeight - 20, panelHeight - 20);
  fill(0, 0, 120);
  stroke(0, 0, 0);
  strokeWeight(1);
  rect(50 + panelHeight, height - panelHeight + 10, 152, 22);
  fill(360, 360, 360);
  noStroke();
  float crystalHP = 150 * (crystal.hp/crystal.maxhp);
  if (crystalHP < 0) {
    crystalHP = 0;
  }
  rect(51 + panelHeight, height - panelHeight + 11, crystalHP, 20);
  textSize(20);
  fill(0, 0, 360);
  text("HP", 10 + panelHeight, height - panelHeight + 30);
  textSize(14);
  fill(0, 0, 360);
  text((int)crystal.hp + "/" + (int)crystal.maxhp, 71 + panelHeight, height - panelHeight + 26);
  if (player == knight) {
    image(sword, 3 * panelHeight, height - panelHeight + 10, panelHeight - 20, panelHeight - 20);
  } else if (player == ranger) {
    image(bow, 3 * panelHeight, height - panelHeight + 10, panelHeight - 20, panelHeight - 20);
  } else if (player == null) {
    image(staff, 3 * panelHeight, height - panelHeight + 10, panelHeight - 20, panelHeight - 20);
  }
  fill(0, 0, 120);
  stroke(0, 0, 0);
  strokeWeight(1);
  rect(50 + 4 * panelHeight, height - panelHeight + 10, 152, 22);
  fill(360, 360, 360);
  noStroke();
  float playerHP = 150 * (player.hp/player.maxhp);
  if (playerHP < 0) {
    playerHP = 0;
  }
  rect(51 + 4 * panelHeight, height - panelHeight + 11, playerHP, 20);
  textSize(20);
  fill(0, 0, 360);
  text("HP", 10 + 4 * panelHeight, height - panelHeight + 30);
  textSize(14);
  fill(0, 0, 360);
  text((int)player.hp + "/" + (int)player.maxhp, 91 + 4 * panelHeight, height - panelHeight + 26);

  fill(0, 0, 120);
  stroke(0, 0, 0);
  strokeWeight(1);
  rect(50 + 4 * panelHeight, height - panelHeight + 40, 152, 22);
  fill(300, 360, 360);
  noStroke();
  float playerEN = 150 * (player.en/player.maxen);
  if (playerEN < 0) {
    playerEN = 0;
  }
  rect(51 + 4 * panelHeight, height - panelHeight + 41, playerEN, 20);
  textSize(20);
  fill(0, 0, 360);
  text("EN", 10 + 4 * panelHeight, height - panelHeight + 60);
  textSize(14);
  fill(0, 0, 360);
  text((int)player.en + "/" + (int)player.maxen, 91 + 4 * panelHeight, height - panelHeight + 56);

  image(goldBag, 10 + 4 * panelHeight, height - panelHeight + panelHeight/2, 50, 50);
  textSize(25);
  fill(60, 360, 360);
  text((int)player.gold, 70 + 4 * panelHeight, height - panelHeight + panelHeight/2 + 35);

  fill(0);
  image(wall, 10 + 6 * panelHeight, height - panelHeight + panelHeight/2 - 25, panelHeight/2, panelHeight/2);
  textSize(panelHeight/4 - 20);
  text(50, 30 + 6 * panelHeight, height - panelHeight + (panelHeight*1)/4);
  textSize(panelHeight/2 - 20);
  text(1, 30 + 6 * panelHeight, height - panelHeight + (panelHeight*3)/4);
  
  image(wall, 10 + 7 * panelHeight + panelHeight/5, height - panelHeight + panelHeight/2 - 25, panelHeight/6, panelHeight/2);
  textSize(panelHeight/4 - 20);
  text(100, 30 + 7 * panelHeight, height - panelHeight + (panelHeight*1)/4);
  textSize(panelHeight/2 - 20);
  text(2, 30 + 7 * panelHeight, height - panelHeight + (panelHeight*3)/4);
  
  image(wall, 10 + 8 * panelHeight, height - panelHeight + panelHeight/2 - 25, panelHeight/2, panelHeight/2);
  image(sword, 10 + 8 * panelHeight, height - panelHeight + panelHeight/2 - 25, panelHeight/2, panelHeight/2);
  textSize(panelHeight/4 - 20);
  text(150, 30 + 8 * panelHeight, height - panelHeight + (panelHeight*1)/4);
  textSize(panelHeight/2 - 20);
  text(3, 30 + 8 * panelHeight, height - panelHeight + (panelHeight*3)/4);
  
  image(wall, 10 + 9 * panelHeight, height - panelHeight + panelHeight/2 - 25, panelHeight/2, panelHeight/2);
  image(bow, 10 + 9 * panelHeight, height - panelHeight + panelHeight/2 - 25, panelHeight/2, panelHeight/2);
  textSize(panelHeight/4 - 20);
  text(150, 30 + 9 * panelHeight, height - panelHeight + (panelHeight*1)/4);
  textSize(panelHeight/2 - 20);
  text(4, 30 + 9 * panelHeight, height - panelHeight + (panelHeight*3)/4);
  
  image(wrench, 10 + 10 * panelHeight, height - panelHeight + panelHeight/2 - 25, panelHeight/2, panelHeight/2);
  textSize(panelHeight/4 - 20);
  text("-%hp", 30 + 10 * panelHeight, height - panelHeight + (panelHeight*1)/4);
  textSize(panelHeight/2 - 20);
  text(5, 30 + 10 * panelHeight, height - panelHeight + (panelHeight*3)/4);
  
  image(goldBag, 10 + 11 * panelHeight, height - panelHeight + panelHeight/2 - 25, panelHeight/2, panelHeight/2);
  textSize(panelHeight/4 - 20);
  text("+%50", 30 + 11 * panelHeight, height - panelHeight + (panelHeight*1)/4);
  textSize(panelHeight/2 - 20);
  text(6, 30 + 11 * panelHeight, height - panelHeight + (panelHeight*3)/4);
}

void drawFloor() { 
  //tint(255, 126);
  noTint();
  for (int i = 0; i < (width / grassSize) + 3; i++) {
    for (int j = 0; j < (width / grassSize) + 5; j++) {
      image(grassTile, -50 + (j * (grassSize-10)), -50 + (i * (grassSize-10)), grassSize, grassSize);
    }
  }
}

void enemyDead(Enemy enemy, int i) {
  enemy.alive = false;
  decayEnemies.add(enemy);
  enemies.remove(i);
  if (!gameOver) {
    if (enemy.size == 25) {
      score += 1;
    }
    player.gold += 1 * enemy.size/15;
  }
}

void gameOver() {
  textAlign(CENTER);
  textSize(panelHeight);
  fill(360, 360, 360);
  text("GAME OVER", width/2, height/2 - 200);
  text("Score: " + score, width/2, height/2);
  text("Hit <Enter> to Retry", width/2, height/2 + 200);
  textAlign(LEFT);
}

void draw() {

  if (selectionScreen) {
    chooseCharacter();
  } else {

    drawFloor();

    for (int i = 0; i < gridHeight + 1; i++) {
      for (int j = 0; j < gridWidth + 1; j++) {
        Tower t = grid.get(i).get(j);
        if (t != null) {
          if (t.hp <= 0) {
            grid.get(i).set(j, null);
          } else {
            t.drawTower();
            if (!gameOver) {
              if (frameCount % 50 == t.frameMade) {
                t.shoot();
              }
            }
            if (t.decay) {
              t.hp -= 200;
            }
          }
        }
      }
    }

    if ((frameCount - frameCountSpawn) % 350 == 0) {
      Spawner s = new Spawner(5000, 100);
      spawners.add(s);
    }
    
    if ((frameCount - frameCountSpawn) % 2000 == 0) {
      for(int i = 0; i < (frameCount - frameCountSpawn)/30; i++) {
        Zombie zombie = new Zombie(100, 5, new PVector(random(width, width * 1.5), random(0, height)));
        enemies.add(zombie);
      }
    }
    

    if (frameCount - frameCountSpawn >= 500) {
      for (int i = spawners.size() - 1; i >= 0; i--) {
        Spawner s = spawners.get(i);
        if (s.hp <= 0) {
          spawners.remove(s);
          continue;
        }
        s.drawSpawner();
        s.spawn();
      }
    }

    //Arrow collision:
    for (int i = 0; i < arrows.size(); i++) {
      Arrow arrow = arrows.get(i);
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy enemy = enemies.get(j);
        if (arrow.location.x < enemy.location.x + enemy.size &&
          arrow.location.x > enemy.location.x - enemy.size &&
          arrow.location.y < enemy.location.y + enemy.size &&
          arrow.location.y > enemy.location.y - enemy.size) {
          enemy.hp -= 125;
          if (!arrow.power) {
            arrows.remove(i);
            break;
          }
        }
      }
    }
    //Arrow collision for spawners
    //for (int i = 0; i < arrows.size(); i++) {
    //  Arrow arrow = arrows.get(i);
    //  for (int k = spawners.size() - 1; k >= 0; k--) {
    //    Spawner spawner = spawners.get(k);
    //    if (arrow.location.x < spawner.location.x + spawner.size/2 &&
    //      arrow.location.x > spawner.location.x - spawner.size/2 &&
    //      arrow.location.y < spawner.location.y + spawner.size/2 &&
    //      arrow.location.y > spawner.location.y - spawner.size/2) {
    //      if (!arrow.power) {
    //        spawner.hp -= 100;
    //      } else {
    //        spawner.hp -= 500;
    //      }
    //      if (!arrow.power) {
    //        arrows.remove(i);
    //        break;
    //      }
    //    }
    //  }
    //}

    if ((slashSword || slashSwordCircle) && !holdSlashSword) {
      for (int i = enemies.size() - 1; i >= 0; i--) {
        Enemy enemy = enemies.get(i);
        float distx = enemy.location.x - player.location.x;
        float disty = enemy.location.y - player.location.y;
        float dist = sqrt(distx * distx + disty * disty);
        if (slashSwordCircle) {
          if (dist < slashSize/2 + 25) {
            enemy.hp -= 150;
          }
        } else if (slashSword) {
          float enemyAngle = atan2(disty, distx);
          float playerAngle = player.angle - HALF_PI;
          if (dist <= slashSize/2 + 25) {

            if (playerAngle > HALF_PI && playerAngle < PI) {
              if ((enemyAngle > -PI && enemyAngle < playerAngle - PI - HALF_PI) ||
                (enemyAngle > playerAngle - HALF_PI && enemyAngle < PI)) {
                enemy.hp -= 75;
              }
            } else if (playerAngle > -PI && playerAngle < -HALF_PI) {
              if ((enemyAngle > playerAngle + PI + HALF_PI && enemyAngle < PI) ||
                enemyAngle > -PI && enemyAngle < playerAngle + HALF_PI) {
                enemy.hp -= 75;
              }
            } else {
              if (enemyAngle > playerAngle - HALF_PI && enemyAngle < playerAngle + HALF_PI) {
                enemy.hp -= 75;
              }
            }
          }
        }
      }
    }

    if (holdSlashSword) {
      for (int i = enemies.size() - 1; i >= 0; i--) {
        Enemy enemy = enemies.get(i);
        float distx = enemy.location.x - player.location.x;
        float disty = enemy.location.y - player.location.y;
        float dist = sqrt(distx * distx + disty * disty);
        float enemyAngle = atan2(disty, distx);
        if (dist <= holdSlashSize + 25) {
          if ((enemyAngle > holdSlashAngle - .1 && enemyAngle < holdSlashAngle + .1) || dist <= 1) {
            enemy.hp -= 30;
          }
        }
      }
    }

    //Draw decayed enemies
    for (int i = decayEnemies.size() - 1; i >= 0; i--) {
      Enemy en = decayEnemies.get(i);
      en.drawEnemy();
      if (en.alpha < 0) {
        decayEnemies.remove(i);
      } else {
        en.alpha -= 20;
      }
    }

    //Draw villagers
    for (int i = villagers.size() - 1; i >= 0; i--) {
      Villager v = villagers.get(i);
      v.drawVillager();
      v.moveVillager();
      player.gold += .005;
      if (v.hp <= 0) {
        villagers.remove(i);
      }
    }

    //Enemies with <= 0 hp die
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      if (enemy.hp <= 0) {
        enemyDead(enemy, i);
      }
    }

    //Draw enemies
    for (int i = 0; i < enemies.size(); i++) {
      Enemy en = enemies.get(i);
      en.moveEnemy();
      en.drawEnemy();
    }

    //Draw arrows
    for (int i = 0; i < arrows.size(); i++) {
      Arrow a = arrows.get(i);
      a.moveArrow();
      a.drawArrow();      
      if (a.location.x > width || a.location.x < 0 || a.location.y > height - panelHeight || a.location.y < 0) {
        arrows.remove(i);
      }
    }
  
    //Draw player
    if (player.alive) {
      player.drawPlayer();
      player.movePlayer();
    } else {
      player.location = crystal.location.copy();
      player.hp += .1;
    }

    //If player hp is less than 0, die
    if (player.hp <= 0 && player.alive) {
      player.alive = false;
    }

    //If player hp reaches 100 again after dead, revive
    if (player.hp >= 100 && !player.alive) {
      player.alive = true;
      player.location = new PVector(crystal.location.x + player.size, crystal.location.y);
    }

    //Draw Crystal and spawn villagers randomly
    crystal.drawCrystal();
    if (frameCount - frameCountSpawn > 500) {
      if (villagers.size() < 25) {
        if (random(0, 1000) < 5) {
          crystal.makeVillager(10, crystal.location);
        }
      }
    }

    //Draw bottom info Panel
    drawPanel();

    //If crystal's hp is below 0, toggle Game Over
    if (crystal.hp <= 0) {
      gameOver = true;
    }

    //Energy regen for Knight
    if (player instanceof Knight) {
      if (player.en <= player.maxen) {
        player.en += .2;
      }
    }

    //Stop shielding
    if (frameCount == stopShieldFrame) {
      player.shielded = false;
    }

    //health regen for player/crystal
    if (player.hp < player.maxhp) {
      player.hp += .02;
    }
    if (crystal.hp < crystal.maxhp) {
      crystal.hp += .1;
    }

    //gameOver conditions
    if (gameOver) {
      gameOver();
      shootArrow = false;
      fanArrow = false;
      slashSword = false;
      holdSlashSword = false;
      slashSwordCircle = false;
      shielding = false;
      autoSwordSlash = false;
    }

    //Countdown
    if (frameCount - frameCountSpawn <= 500) {
      textSize(panelHeight);
      textAlign(CENTER);
      fill(360, 360, 360);
      text("Zombies spawn in... " + (540 -(frameCount - frameCountSpawn))/60, width/2, height/2);
      textAlign(LEFT);
    }

    //Draw score
    textSize(100);
    fill(0, 0, 0);
    scoreSize = Integer.toString(score).length();
    text(score, width - (15 + 65 * scoreSize), 100);
  }
}


// Listen to key press events
void keyPressed() {
  if (keyPressed) {
    switch(key) {
    case 'w':
    case 'W':
      playerMovingUp = true;
      break;
    case 'a': 
    case 'A':
      playerMovingLeft = true;
      break;
    case 'd':
    case 'D':
      playerMovingRight = true;
      break;
    case 's': 
    case 'S':
      playerMovingDown = true;
      break;
    case 'q': 
    case 'Q':
      if (autoSwordSlash) {
        autoSwordSlash = false;
      } else {
        autoSwordSlash = true;
      }
      break;
    case 'r':
    case 'R':
      if (player instanceof Ranger) {
        player.ammo = 0;
      }
    }
    //Only allow building of towers above panel
    if (mouseY < height - panelHeight) {
      int gridX = mouseX/64;
      int gridY = mouseY/64;
      Tower t = grid.get(gridY).get(gridX);
      switch(key) {
      case '1':
        if (t == null && gridY != crystal.gridY || gridX != crystal.gridX) {
          Wall wall = new Wall(5000, new PVector(gridX * 64 + 32, gridY * 64 + 32), gridY, gridX);
          if (player.gold >= wall.cost && t == null) {
            grid.get(gridY).set(gridX, wall);
            player.gold -= wall.cost;
          }
        }
        break;
      case '2':
        if (t == null && gridY != crystal.gridY || gridX != crystal.gridX) {
          Gate gate = new Gate(5000, new PVector(gridX * 64 + 32, gridY * 64 + 32), gridY, gridX);
          if (player.gold >= gate.cost && t == null) {
            grid.get(gridY).set(gridX, gate);
            player.gold -= gate.cost;
          }
        }
        break;
      case '3':
        if (t == null && gridY != crystal.gridY || gridX != crystal.gridX) {
          KnightTower knightTower = new KnightTower(2500, new PVector(gridX * 64 + 32, gridY * 64 + 32), gridY, gridX);
          if (player.gold >= knightTower.cost && t == null) {
            grid.get(gridY).set(gridX, knightTower);
            player.gold -= knightTower.cost;
          }
        }

        break;
      case '4':
        if (t == null && gridY != crystal.gridY || gridX != crystal.gridX) {
          RangerTower rangerTower = new RangerTower(1000, new PVector(gridX * 64 + 32, gridY * 64 + 32), gridY, gridX, frameCount % 50);
          if (player.gold >= rangerTower.cost && t == null) {
            grid.get(gridY).set(gridX, rangerTower);
            player.gold -= rangerTower.cost;
          }
        }
        break;
      case '5':
        if (t != null && !t.decay) {
          float missinghp = t.maxhp - t.hp;
          if (player.gold > (missinghp/t.maxhp) * t.cost) {
            t.hp = t.maxhp;
            player.gold -= (missinghp/t.maxhp) * t.cost;
          }
        }
        break;
      case '6':
        if (t != null && !t.decay) {
          t.decay = true;
          player.gold += (t.cost/2) * (t.hp/t.maxhp);
        }
        break;
      }
    }
  }
}

// Listen to key release events
void keyReleased() {
  switch(key) {
  case 'w':
  case 'W':
    playerMovingUp = false;
    break;
  case 'a': 
  case 'A':
    playerMovingLeft = false;
    break;
  case 'd':
  case 'D':
    playerMovingRight = false;
    break;
  case 's': 
  case 'S':
    playerMovingDown = false;
    break;
  case ENTER:
    if (gameOver) {
      reinitializeGame();
    } else {
      if (player != null) {
        selectionScreen = false;
        frameCountSpawn = frameCount;
      }
      break;
    }
  }
}

//Listen for mouse events
void mousePressed() {
  if (selectionScreen) {
    if (mouseButton == LEFT) {
      if (mouseX > width/5 - width/10 && mouseX < width/5 + width/10 && 
        mouseY < height/2 + 2*height/6 && mouseY > 1*height/6) {
        player = knight;
      }
      if (mouseX > 2*width/5 - width/10 && mouseX < 2*width/5 + width/10 && 
        mouseY < height/2 + 2*height/6 && mouseY > 1*height/6) {
        player = ranger;
      }
      if (mouseX > 3*width/5 - width/10 && mouseX < 3*width/5 + width/10 && 
        mouseY < height/2 + 2*height/6 && mouseY > 1*height/6) {
        //player = mage;
      }
      if (mouseX > 4*width/5 - width/10 && mouseX < 4*width/5 + width/10 && 
        mouseY < height/2 + 2*height/6 && mouseY > 1*height/6) {
        float character = random(0, 3);
        if (character < 1) {
          player = knight;
        } else if (character < 2) {
          player = ranger;
        } else if (character < 3) {
          //player = mage
        }
      }
    }
  } else {
    if (!gameOver && player.alive) {
      if (player == ranger) {
        if (mouseButton == LEFT) {
          if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
            shootArrow = true;
            shootFrame = frameCount;
          }
        }
        if (mouseButton == RIGHT) {
          if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
            fanArrow = true;
            fanFrame = frameCount;
          }
        }
      } else if (player == knight) {
        if (mouseButton == LEFT) {
          if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
            if (!player.shielded) {
              holdSlashSword = true;
            }
            slashFrame = frameCount;
            holdSlashSize = 50;
            holdSlashAngle = player.getAngle() - HALF_PI;
          }
        }
        if (mouseButton == RIGHT) {
          if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
            player.shielded = true;
            shieldFrame = frameCount;
          }
        }
      }
    }
  }
}

//Listen for mouse events
void mouseReleased() {
  if (!gameOver && player.alive) {
    if (player == ranger) {
      if (mouseButton == LEFT) {
        if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
          int holdTime = frameCount - shootFrame;
          if (shootArrow) {
            if (holdTime > 50) {
              if (player.ammo >= 10) {
                Arrow arrow = new Arrow(player.location, player.angle);
                arrow.power = true;
                arrows.add(arrow);
                player.ammo -= 10;
              }
            } else {
              if (player.ammo > 0) {
                Arrow arrow = new Arrow(player.location, player.angle);
                arrows.add(arrow);
                player.ammo -= 1;
              }
            }
          }
        }
      }
      if (mouseButton == RIGHT) {
        if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
          int holdTime = frameCount - fanFrame;
          int arrowCount = holdTime/2;
          if(arrowCount >= 250) {
            arrowCount = 250;
          }
          float arrowIncrement;
          if (fanArrow) {
            if (holdTime > 20) {
              if (player.ammo > 0) {
                arrowIncrement = (HALF_PI+QUARTER_PI/2)/arrowCount;
                for (int i = 0; i < arrowCount; i++) {
                  Arrow arrow = new Arrow(player.location, (player.angle - HALF_PI/2 - QUARTER_PI/4) + arrowIncrement * i);
                  arrows.add(arrow);
                }
                if (arrowCount >= player.ammo) {
                  player.ammo = 0;
                } else {
                  player.ammo -= arrowCount;
                }
              }
            } else {
              if (player.ammo >= 5) {
                arrowIncrement = HALF_PI/4;
                for (int i = 0; i < 5; i++) {
                  Arrow arrow = new Arrow(player.location, (player.angle - HALF_PI/2) + arrowIncrement * i);
                  arrows.add(arrow);
                }
                player.ammo -= 5;
              }
            }
          }
        }
      }
    } else if (player == knight) {
      if (mouseButton == LEFT) {
        if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
          int holdTime = frameCount - slashFrame;
          if (holdTime < 10 && !player.shielded) {
            if (player.en >= 10) {
              slashRadius = PI;
              slashSize = 275;
              slashSword = true;
              player.en -= 10;
            }
          }
          holdSlashSword = false;
        }
      }
      if (mouseButton == RIGHT) {
        if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
          int holdTime = frameCount - shieldFrame;
          if (holdTime < 20) {
            if (player.en >= 20) {
              slashRadius = 2 * PI;
              slashSize = 200;
              slashSwordCircle = true;
              player.shielded = false;
              player.en -= 20;
            }
          }
          stopShieldFrame = frameCount + 10;
        }
      }
    }
  }
}