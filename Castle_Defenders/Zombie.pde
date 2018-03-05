/**
 * Class representing a 'Zombie', a monster
 * Extends 'Enemy' class
 **/
public class Zombie extends Enemy {

  Zombie(float hp, float speed, PVector location) {
    this.hp = hp;
    this.speed = speed;
    this.size = 25;
    this.alpha = 360;
    this.damage = 4;
    this.alive = true;
    this.location = location.copy();
  }

  Zombie() {
  }

  float getAngle(PVector loc) {
    float angle = 0.0;
    float opp = loc.y - location.y;
    float adj = loc.x - location.x;
    angle = atan2(opp, adj);
    return angle;
  }

  void drawEnemy() {
    if (alive) {
      if (speed >= 10) {
        fill(360, 270, 150);
      } else {
        fill(120, 140, 75);
      }
      stroke(0);
      strokeWeight(1);
      ellipse(location.x, location.y, size, size);
    } else {
      fill(360, 100, 50, alpha);
      stroke(0, alpha);
      strokeWeight(1);
      ellipse(location.x, location.y, size, size);
    }
  }


  void moveEnemy() {
    int m = 1;
    float playerAngle = getAngle(player.location);
    float crystalAngle = getAngle(crystal.location);
    float dPlayer = dist(location.x, location.y, player.location.x, player.location.y);
    float dCrystal = dist(location.x, location.y, crystal.location.x, crystal.location.y);
    float dVillager = 10000.0;
    int vi = 0;
    for (int i = 0; i < villagers.size(); i++) {
      Villager vTemp = villagers.get(i);
      float d = dist(location.x, location.y, vTemp.location.x, vTemp.location.y);
      if (d < dVillager) {
        dVillager = d;
        vi = i;
      }
    }
    if (location.x + size/2 > width) {
      location.x -= speed;
    } else if (location.x - size/2 < 0) {
      location.x += speed;
    } else if (location.y + size/2 > height - panelHeight) {
      location.y -= speed;
    } else if (location.y - size/2 < 0) {
      location.y += speed;
    }
    for (int i = 0; i < enemies.size(); i++) {
      Enemy enemy = enemies.get(i);
      if (enemy.location.x == location.x && enemy.location.y == location.y) {
        //do nothing
      } else {
        float d = dist(location.x, location.y, enemy.location.x, enemy.location.y);
        if (size >= d) {
          if (location.x < enemy.location.x) {
            location.x -= speed;
          } else {
            location.x += speed;
          }
          if (location.y < enemy.location.y) {
            location.y -= speed;
          } else {
            location.y += speed;
          }
        }
      }
    }
    for (int i = 0; i < grid.size(); i++) {
      for (int j = 0; j < grid.get(i).size(); j++) {
        Tower t = grid.get(i).get(j);
        if (t != null) {
          float d = dist(location.x, location.y, t.location.x, t.location.y);
          if (size/2 + t.size/2 >= d) {
            m = -2;
            t.hp -= damage - damage * (t.armor/100);
            if (t instanceof KnightTower) {
              hp -= 10;
            }
          }
        }
      }
    }
    if ((dVillager*3)/4 <= dPlayer && dVillager/2 <= dCrystal) {
      if (villagers.get(vi).size >= dVillager) {
        if (location.x < villagers.get(vi).location.x) {
          location.x -= 2*speed;
        } else {
          location.x += 2*speed;
        }
        if (location.y < villagers.get(vi).location.y) {
          location.y -= 2*speed;
        } else {
          location.y += 2*speed;
        }
        villagers.get(vi).hp -= damage;
      }
      float villagerAngle = getAngle(villagers.get(vi).location);
      location.x += m * speed * cos(villagerAngle);
      location.y += m * speed * sin(villagerAngle);
    } else if (dPlayer < dCrystal) {
      if (player.size/2 >= dPlayer) {
        if (location.x < player.location.x) {
          location.x -= 2*speed;
        } else {
          location.x += 2*speed;
        }
        if (location.y < player.location.y) {
          location.y -= 2*speed;
        } else {
          location.y += 2*speed;
        }
        if (!player.shielded) {
          player.hp -= (damage) - damage * player.armor/100;
        }
        player.damaged = true;
      }
      location.x += m * speed * cos(playerAngle);
      location.y += m * speed * sin(playerAngle);
    } else {
      if (crystal.size/2 >= dCrystal) {
        if (location.x < crystal.location.x) {
          location.x -= 2*speed;
        } else {
          location.x += 2*speed;
        }
        if (location.y < crystal.location.y) {
          location.y -= 2*speed;
        } else {
          location.y += 2*speed;
        }
        if (!crystal.shielded) {
          crystal.hp -= damage;
        }
        crystal.damaged = true;
      }
      location.x += m * speed * cos(crystalAngle);
      location.y += m * speed * sin(crystalAngle);
    }
  }
}