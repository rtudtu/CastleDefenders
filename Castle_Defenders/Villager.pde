public class Villager {
  float hp;
  float speed;
  float velX;
  float velY;
  float size;
  boolean builder;
  PVector location;



  Villager(float hp, PVector location) {
    this.hp = hp;
    this.speed = random(1, 3);
    velX = random(-2, 2);
    velY = random(-2, 2);
    this.size = 25;
    if (random(0, 1000) < 200) {
      builder = true;
    } else {
      builder = false;
    }
    this.location = location.copy();
  }

  void drawVillager() {
    if (builder) {
      fill(0, 0, 120);
    } else {
      fill(240, 360, 360);
    }
    stroke(0);
    strokeWeight(1);
    ellipse(location.x, location.y, size, size);
  }

  void randomVel() {
    velX = random(-2, 2);
    velY = random(-2, 2);
  }

  void repairTower(Tower t) {
    if (builder) {
      if (t.hp + 5 <= t.maxhp) {
        t.hp += 5;
      }
    }
  }

  void moveVillager() {
    if (location.x + size/2 > width) {
      location.x += -speed * 3;
      randomVel();
    } else if (location.x - size/2 < 0) {
      location.x += speed * 3;
      randomVel();
    } else if (location.y + size/2 > height - panelHeight) {
      location.y += -speed * 3;
      randomVel();
    } else if (location.y - size/2 < 0) {
      location.y += speed * 3;
      randomVel();
    }

    for (int i = 0; i < grid.size(); i++) {
      for (int j = 0; j < grid.get(i).size(); j++) {
        Tower t = grid.get(i).get(j);
        if (t != null) {
          if (location.x + size/2 > t.location.x - (t.size)/2 &&
            location.x + size/2 < t.location.x &&
            location.y < t.location.y + t.size &&
            location.y > t.location.y - t.size) {
            location.x += -speed * 3;
            randomVel();
            repairTower(t);
          } 
          if (location.x - size/2 < t.location.x + (t.size)/2 &&
            location.x - size/2 > t.location.x &&
            location.y < t.location.y + t.size &&
            location.y > t.location.y - t.size) {
            location.x += speed * 3;
            randomVel();
            repairTower(t);
          } 
          if (location.y + size/2 > t.location.y - (t.size)/2 &&
            location.y - size/2 < t.location.y &&
            location.x < t.location.x + t.size &&
            location.x > t.location.x - t.size) {
            location.y += -speed * 3;
            randomVel();
            repairTower(t);
          } 
          if (location.y - size/2 < t.location.y + (t.size)/2 &&
            location.y + size/2 > t.location.y &&
            location.x < t.location.x + t.size &&
            location.x > t.location.x - t.size) {
            location.y += speed * 3;
            randomVel();
            repairTower(t);
          }
        }
      }
    }
    location.x += velX;
    location.y += velY;
  }
}