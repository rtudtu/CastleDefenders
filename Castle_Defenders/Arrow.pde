class Arrow {
  float speed;
  float angle;
  float size;
  PVector location;
  boolean power;

  Arrow(PVector loc, float angle) {
    this.speed = 35;
    this.angle = angle;
    this.size = 64;
    this.power = false;
    this.location = loc.copy();
  }


  void drawArrow() {
    if (power) {
      imageMode(CENTER);
      pushMatrix();
      translate(location.x, location.y);
      rotate(angle);
      image(arrow, 0, 45, size/2, (3*size)/2);
      popMatrix();
      imageMode(CORNER);
    } else {
      imageMode(CENTER);
      pushMatrix();
      translate(location.x, location.y);
      rotate(angle);
      image(arrow, 0, size/2, size/3, size);
      popMatrix();
      imageMode(CORNER);
    }
  }

  void moveArrow() {
    //move arrow at the given speed and angle
    float temp = angle;
    temp -= HALF_PI;
    if (power) {
      this.location.x += speed*3/4 * cos(temp);
      this.location.y += speed*3/4 * sin(temp);
    } else {
      this.location.x += speed * cos(temp);
      this.location.y += speed * sin(temp);
    }
  }
}