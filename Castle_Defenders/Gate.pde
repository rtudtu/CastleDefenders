public class Gate extends Tower {

  Gate(float hp, PVector location, int gridY, int gridX) {
    this.maxhp = hp;
    this.hp = hp;
    this.armor = 25;
    this.size = 64;
    this.cost = 100;
    this.location = location;
    this.gridY = gridY;
    this.gridX = gridX;
    this.decay = false;
    this.frameMade = 1;
  }

  void drawTower() {
    imageMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    noFill();
    stroke(0, 360);
    strokeWeight(1);
    rectMode(CENTER);
    tint(360, 360 * (hp/maxhp));
    if (grid.get(gridY).get(gridX - 1) != null && grid.get(gridY).get(gridX + 1) != null) {
      rect(0, 0, size, size/3);
      image(wall, 0, 0, size, size/3);
    } else {
      rect(0, 0, size/3, size);
      image(wall, 0, 0, size/3, size);
    }
    rectMode(CORNER);
    noTint();
    popMatrix();
    imageMode(CORNER);
  }

  void shoot() {
  }
}