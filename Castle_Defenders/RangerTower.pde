public class RangerTower extends Tower {
  int ammo;
  int reloadFrame;
  int reloadTime;
  boolean reload;

  RangerTower(float hp, PVector location, int gridY, int gridX, int frameMade) {
    this.maxhp = hp;
    this.hp = hp;
    this.armor = 25;
    this.size = 64;
    this.cost = 150;
    this.location = location;
    this.gridY = gridY;
    this.gridX = gridX;
    this.decay = false;
    this.frameMade = frameMade;
    this.ammo = 25;
    this.reloadFrame = 0;
    this.reloadTime = 400;
    this.reload = false;
  }

  float getAngle(PVector loc) {
    float angle = 0.0;
    float opp = location.y - loc.y;
    float adj = location.x - loc.y;
    angle = atan2(opp, adj);
    return angle;
  }

  void drawTower() {    
    if (ammo <= 0 && !reload) {
      reload = true;
      reloadFrame = frameCount;
    }
    if (frameCount-reloadFrame >= reloadTime && reload) {
      reload = false;
      ammo = 25;
    }
    imageMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    tint(360, 360 * (hp/maxhp));
    noFill();
    stroke(0, 360);
    strokeWeight(1);
    rectMode(CENTER);
    rect(0, 0, size, size);
    rectMode(CORNER);
    image(wall, 0, 0, size, size);
    image(bow, 0, 0, size, size);
    noTint();
    if (reload) {
      fill(360, 360, 360);
      rect(-size/2, -size/6, size * (((float)frameCount-reloadFrame) / (float)reloadTime), size/3);
    }
    popMatrix();
    imageMode(CORNER);
  }

  void shoot() {
    if (!reload) {
      float a = 1;
      float d = 100000;
      for (int i = 0; i < enemies.size(); i++) {
        float d2 = dist(location.x, location.y, enemies.get(i).location.x, enemies.get(i).location.y);
        if (d2 < d) {
          d = d2;
          float opp = location.y - enemies.get(i).location.y;
          float adj = location.x - enemies.get(i).location.x;
          a = atan2(opp, adj);
        }
      }
      Arrow arrow = new Arrow(location, a - HALF_PI);
      arrows.add(arrow);
      this.ammo -= 1;
    }
  }
}