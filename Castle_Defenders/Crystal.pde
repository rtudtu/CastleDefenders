public class Crystal {
  float maxhp;
  float hp;
  float size;
  boolean damaged;
  boolean shielded;
  PVector location;
  int gridX;
  int gridY;

  Crystal(float hp) {
    this.maxhp = hp;
    this.hp = hp;
    this.size = 64;
    this.damaged = false;
    this.shielded =false;
    //location = new PVector(random((width*3)/4 + size, width - 2*size), random(0 + size, height - panelHeight - 2*size));
    this.gridX = (int)random(gridWidth*.75, gridWidth - 2);
    this.gridY = (int)random(0, gridHeight - 1);
    location = new PVector(gridX * 64 + 32, gridY * 64 + 32);
}

  void drawCrystal() {
    imageMode(CENTER);
    if (this.damaged) {
      tint(360, 360, 360, 360);
    }
    image(crystalSprite, location.x, location.y, size * 1.2, size * 1.2);
    noTint();
    imageMode(CORNER);
    if (frameCount % 15 == 0) {
      this.damaged = false;
    }
  }
  
  void makeVillager(float hp, PVector loc) {
    Villager villager = new Villager(hp, loc);
    villagers.add(villager);
  }
}