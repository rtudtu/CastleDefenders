/**
 * Class representing a 'Ranger', an archer
 * Extends 'Player' class
 **/
public class Knight extends Player {

  Knight() {
    this.maxhp = 100;
    this.hp = 100;
    this.speed = 8;
    this.size = 64;
    this.en = 100;
    this.maxen = 100;
    this.armor = 75;
    this.gold = 1500;
    this.location = new PVector((width*3)/4, height/2);
    this.shielded = false;
    this.damaged = false;
    this.alive = true;
  }

  @ Override void drawPlayer() {
    if (alive) {
      if (en >= 0 && shielded) {
        en -= .4;
      } else {
        shielded = false;
      }
      imageMode(CENTER);
      pushMatrix();
      translate(location.x, location.y);
      angle = getAngle();
      rotate(angle);
      if (damaged) {
        tint(360, 360, 360, 360);
      }
      image(knightLoaded, 0, 0, size, size);
      if (shielded && frameCount - shieldFrame >  10) {
        fill(150, 360, 360, 200);
        noStroke();
        ellipse(0, 0, size, size);
      } 
      if (holdSlashSword && frameCount - slashFrame > 10) {
        rotate(-angle);
        rotate(holdSlashAngle);
        stroke(0, 0, 360, 300);
        strokeWeight(10);
        line(size/2 - 2, 0, holdSlashSize, 0);
        if (holdSlashSize <= 100) {
          holdSlashSize += 5;
        }
        if (autoSwordSlash) {
          if (holdSlashAngle > PI) {
            holdSlashAngle = -PI;
          }
          holdSlashAngle += .05;
        } else {
          holdSlashAngle = angle - HALF_PI;
        }
      } else if (slashSword || slashSwordCircle) {
        slash(slashRadius);
      }
      popMatrix();
      imageMode(CORNER);
      if (frameCount % 15 == 0) {
        this.damaged = false;
      }
      noTint();
    }
  }

  void slash(float slashRadius) {
    fill(0, 0, 360, 300);
    noStroke();
    rotate(PI);
    arc(0, 0, slashSize, slashSize, 0, slashRadius);
    slashSword = false;
    slashSwordCircle = false;
  }
}