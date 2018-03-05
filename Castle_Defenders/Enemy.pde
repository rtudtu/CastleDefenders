/**
 * Abstract class 'Enemy' for all enemies
 **/
abstract class Enemy {
  float hp;
  float speed;
  float size;
  float alpha;
  float damage;
  boolean alive;
  PVector location;

  abstract void drawEnemy();
  
  abstract void moveEnemy();
  
}