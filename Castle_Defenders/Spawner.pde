public class Spawner {
  float maxhp;
  float hp;
  float size;
  float flow;
  PVector location;


  Spawner(float hp, float flow) {
    this.maxhp = hp;
    this.hp = hp;
    this.size = 80;
    this.flow = flow;
    this.location = new PVector(random(0, width/2), random(0, height - panelHeight));
  }

  void drawSpawner() {
    fill((120*hp)/maxhp, 360, 240);
    stroke(0, 360);
    strokeWeight(1);
    rectMode(CENTER);
    rect(this.location.x, this.location.y, this.size, this.size);
    rectMode(CORNER);
  }

  void spawn() {
    //flow += ((float)frameCount - (float)frameCountSpawn - 600)/500000;
    float mult = ((float)frameCount - (float)frameCountSpawn - 600)/30000;
    if (mult > 1) {
      mult = 1;
    }
    //if (flow > 250) {
    //  flow = 250;
    //}
    //textSize(100);
    //text(mult, 1000, 1000);
    float spawn = random(0, 10000);
    if (spawn < flow/20 + mult*(flow/2)) {
      Zombie zombie = new Zombie(100 + mult * 150, 10, this.location);
      enemies.add(zombie);
    } else if (spawn < flow) {
      Zombie zombie = new Zombie(100 + mult * 150, 3, this.location);
      enemies.add(zombie);
    }
  }
}