public class Wall extends Tower {
 
  Wall(float hp, PVector location, int gridY, int gridX) {
    this.maxhp = hp;
    this.hp = hp;
    this.armor = 50;
    this.size = 64;
    this.cost = 50;
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
    tint(360, 360 * (hp/maxhp));
    noFill();
    stroke(0, 360);
    strokeWeight(1);
    rectMode(CENTER);
    rect(0, 0, size, size);
    rectMode(CORNER);
    image(wall, 0, 0, size, size);
    noTint();
    popMatrix();
    imageMode(CORNER);
  }
  
  void shoot() {
    
  }
  
  
  
}