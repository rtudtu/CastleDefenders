/**
 * Abstract Class 'Player' for all player type options
 **/
abstract class Player {
  int ammo;
  float maxhp;
  float hp;
  float speed;
  float angle;
  float size;
  float en;
  float maxen;
  float armor;
  float gold;
  PVector location;
  boolean shielded;
  boolean damaged;
  boolean alive;

  float getAngle() {
    float opp = mouseY - location.y;
    float adj = mouseX - location.x;
    angle = atan2(opp, adj);
    angle += HALF_PI;
    return angle;
  }

  abstract void drawPlayer();

  void movePlayer() {
    float m = 1;
    if (location.x + size/2 > width) {
      location.x -= speed;
    } else if (location.x - size/2 < 0) {
      location.x += speed;
    } else if (location.y + size/2 > height - panelHeight) {
      location.y -= speed;
    } else if (location.y - size/2 < 0) {
      location.y += speed;
    }
    if (location.x + size/2 > crystal.location.x - (crystal.size*m)/2 &&
      location.x + size/2 < crystal.location.x &&
      location.y < crystal.location.y + crystal.size/2 &&
      location.y > crystal.location.y - crystal.size/2) {
      location.x -= speed;
    } else if (location.x - size/2 < crystal.location.x + (crystal.size*m)/2 &&
      location.x - size/2 > crystal.location.x &&
      location.y < crystal.location.y + crystal.size/2 &&
      location.y > crystal.location.y - crystal.size/2) {
      location.x += speed;
    } else if (location.y + size/2 > crystal.location.y - (crystal.size*m)/2 &&
      location.y - size/2 < crystal.location.y &&
      location.x < crystal.location.x + crystal.size/2 &&
      location.x > crystal.location.x - crystal.size/2) {
      location.y -= speed;
    } else if (location.y - size/2 < crystal.location.y + (crystal.size*m)/2 &&
      location.y + size/2 > crystal.location.y &&
      location.x < crystal.location.x + crystal.size/2 &&
      location.x > crystal.location.x - crystal.size/2) {
      location.y += speed;
    }
    for (int i = 0; i < spawners.size(); i++) {
      Spawner spawner = spawners.get(i);
      if (location.x + size/2 > spawner.location.x - (spawner.size)/2 &&
        location.x + size/2 < spawner.location.x &&
        location.y < spawner.location.y + spawner.size/2 &&
        location.y > spawner.location.y - spawner.size/2) {
        location.x -= speed;
      } else if (location.x - size/2 < spawner.location.x + (spawner.size)/2 &&
        location.x - size/2 > spawner.location.x &&
        location.y < spawner.location.y + spawner.size/2 &&
        location.y > spawner.location.y - spawner.size/2) {
        location.x += speed;
      } else if (location.y + size/2 > spawner.location.y - (spawner.size)/2 &&
        location.y - size/2 < spawner.location.y &&
        location.x < spawner.location.x + spawner.size/2 &&
        location.x > spawner.location.x - spawner.size/2) {
        location.y -= speed;
      } else if (location.y - size/2 < spawner.location.y + (spawner.size)/2 &&
        location.y + size/2 > spawner.location.y &&
        location.x < spawner.location.x + spawner.size/2 &&
        location.x > spawner.location.x - spawner.size/2) {
        location.y += speed;
      }
    }
    for (int i = 0; i < grid.size(); i++) {
      for (int j = 0; j < grid.get(i).size(); j++) {
        Tower t = grid.get(i).get(j);
        if (t != null && !(t instanceof Gate)) {
          if (location.x + size/2 > t.location.x - (t.size)/2 &&
            location.x + size/2 < t.location.x &&
            location.y < t.location.y + t.size/2 + 1 &&
            location.y > t.location.y - t.size/2 + 1) {
            location.x -= speed;
          } 
          if (location.x - size/2 < t.location.x + (t.size)/2 &&
            location.x - size/2 > t.location.x &&
            location.y < t.location.y + t.size/2 + 1 &&
            location.y > t.location.y - t.size/2 + 1) {
            location.x += speed;
          } 
          if (location.y + size/2 > t.location.y - (t.size)/2 &&
            location.y - size/2 < t.location.y &&
            location.x < t.location.x + t.size/2 + 1 &&
            location.x > t.location.x - t.size/2 + 1) {
            location.y -= speed;
          } 
          if (location.y - size/2 < t.location.y + (t.size)/2 &&
            location.y + size/2 > t.location.y &&
            location.x < t.location.x + t.size/2 + 1 &&
            location.x > t.location.x - t.size/2 + 1) {
            location.y += speed;
          }
        }
      }
    }
    if (playerMovingUp) {
      location.y -= speed;
    }
    if (playerMovingLeft) {
      location.x -= speed;
    }
    if (playerMovingRight) {
      location.x += speed;
    }
    if (playerMovingDown) {
      location.y += speed;
    }
  }
}