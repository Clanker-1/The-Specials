// Bullet the specials
class Bullet {
  float x, y, angle, speed = 8;
  int size = 5;
  float damage = 20;

  Bullet(float startX, float startY, float startAngle) {
    x = startX;
    y = startY;
    angle = startAngle;
  }

  void update() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;
  }

  void display() {
    fill(255, 255, 0);
    noStroke();
    ellipse(x, y, size, size);
  }
  
  boolean isOffScreen() {
    return (x < 0 || x > width || y < 0 || y > height);
  }

  boolean checkWallCollision(Wall w) {
    // AABB collision check for bullet and wall
    if (x + size/2 > w.x - w.w/2 && x - size/2 < w.x + w.w/2 &&
        y + size/2 > w.y - w.h/2 && y - size/2 < w.y + w.h/2) {
      return true;
    }
    return false;
  }

  boolean checkTankCollision(Tank t) {
    // Simple distance check for bullet and tank center
    if (dist(x, y, t.x, t.y) < t.size / 2) {
      t.takeDamage(damage); // Apply damage
      return true;
    }
    return false;
  }
}
