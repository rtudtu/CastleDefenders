/**
 * Class representing a 'Ranger', an archer
 * Extends 'Player' class
 **/
public class Ranger extends Player {
  int reloadFrame;
  int reloadTime;
  boolean reload;

  Ranger() {
    this.ammo = 50;
    this.maxhp = 100;
    this.hp = 100;
    this.speed = 8;
    this.size = 64;
    this.armor = 25;
    this.gold = 1500;
    this.location = new PVector((width*3)/4, height/2);
    this.reloadFrame = 0;
    this.reloadTime = 150;
    this.shielded = false;
    this.damaged = false;
    this.alive = true;
  }


  @ Override void drawPlayer() {
    if (alive) {
      if (ammo <= 0 && !reload) {
        reload = true;
        reloadFrame = frameCount;
      }
      if (frameCount-reloadFrame >= reloadTime && reload) {
        reload = false;
        ammo = 50;
      }
      imageMode(CENTER);
      pushMatrix();
      translate(location.x, location.y);
      angle = getAngle();
      float tempAngle = angle + radians(50);
      rotate(tempAngle);
      if (damaged) {
        tint(360, 360, 360, 360);
      }
      image(rangerLoaded, 0, 0, size, size);
      rotate(-tempAngle);
      if (reload) {
        fill(360, 360, 360);
        rect(-size/2, -size/6, size * (((float)frameCount-reloadFrame) / (float)reloadTime), size/5);
      }
      textAlign(CENTER);
      textSize(size/3);
      fill(0);
      text((int)ammo + "/" + 50, 5, size/2 + 10);
      textAlign(LEFT);
      popMatrix();
      imageMode(CORNER);
      if (frameCount % 15 == 0) {
        damaged = false;
      }
      noTint();
    }
  }
}