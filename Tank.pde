// Tank the specials
class Tank {
  float x, y, angle, turretAngle;
  float speed = 2.5; 
  float rotationSpeed = 0.05;
  int size = 30;
  color tankColor;
  float hitBoxW = 30;
  float hitBoxH = 21;

  float maxHealth = 100;
  float currentHealth;

  boolean movingForward = false;
  boolean movingBackward = false;
  boolean turningLeft = false;
  boolean turningRight = false;
  
  int lastShotTime = 0;
  int shootDelay = 30;

  Tank(float startX, float startY, color c) {
    x = startX;
    y = startY;
    angle = 0;
    tankColor = c;
    currentHealth = maxHealth;
  }
  
  void update() {
    // Movement and aiming logic remains the same as before
    if (movingForward) {
      x += cos(angle) * speed;
      y += sin(angle) * speed;
    }
    if (movingBackward) {
      x -= cos(angle) * speed;
      y -= sin(angle) * speed;
    }
    if (turningLeft) angle -= rotationSpeed;
    if (turningRight) angle += rotationSpeed;
    turretAngle = atan2(mouseY - y, mouseX - x);

    x = constrain(x, size/2, width - size/2);
    y = constrain(y, size/2, height - size/2);
  }

  void checkCollision(ArrayList<Wall> walls) {
    for (Wall w : walls) {
      if (x + hitBoxW/2 > w.x - w.w/2 && x - hitBoxW/2 < w.x + w.w/2 &&
          y + hitBoxH/2 > w.y - w.h/2 && y - hitBoxH/2 < w.y + w.h/2) {
        
        if (movingForward || movingBackward) {
           float angleOfImpact = atan2(y - w.y, x - w.x);
           x += cos(angleOfImpact) * speed * 2;
           y += sin(angleOfImpact) * speed * 2;
        }
      }
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);

    fill(tankColor);
    rect(0, 0, size, size * 0.7);

    pushMatrix();
    rotate(turretAngle - angle); 
    fill(100, 100, 100);
    rect(0, 0, size * 0.6, size * 0.4);
    rect(size * 0.35, 0, size * 0.7, size * 0.1);
    popMatrix();

    popMatrix();
    
    displayHealth(); // Call the health bar display function
  }

  void displayHealth() {
    float barWidth = 40;
    float barHeight = 5;
    float healthPercentage = currentHealth / maxHealth;

    // Background of health bar (red)
    fill(255, 0, 0);
    rect(x, y - size - 10, barWidth, barHeight);

    // Foreground of health bar (green)
    fill(0, 255, 0);
    rect(x - (barWidth/2) * (1 - healthPercentage), y - size - 10, barWidth * healthPercentage, barHeight);
  }
  
  void takeDamage(float damage) {
    currentHealth -= damage;
    if (currentHealth <= 0) {
      currentHealth = 0;
      // Handle tank destruction here (e.g., game over, remove enemy)
      println("Tank destroyed!");
    }
  }

  void shoot() {
    if (millis() > lastShotTime + shootDelay * (1000/frameRate)) {
      bullets.add(new Bullet(x, y, turretAngle));
      lastShotTime = millis();
    }
  }
}
