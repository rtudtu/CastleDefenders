/**
 * Abstract Class 'Tower' for all wall and tower types
 **/
public abstract class Tower {
  float maxhp;
  float hp;
  float armor;
  float size;
  float cost;
  PVector location;
  int gridY;
  int gridX;
  int frameMade;
  boolean decay;


  abstract void drawTower();

  abstract void shoot();
}