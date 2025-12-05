// Franklin, Osckar, and Henry contributed

// Define states outside the class
enum State {
  IDLE, ATTACK
}

class EnemyTank extends Tank {
  float chaseDistance = 650;   // Distance from player to start chasing
  float stopDistance  = 250;   // Distance from player to stop chasing
  int lastShotTime = 0;
  int shootDelay = 100;

  State currentState = State.IDLE;

  EnemyTank(float startX, float startY, color c) {
    super(startX, startY, c);
  }

  void update(Tank player) {
    float d = dist(x, y, player.x, player.y);
    turretAngle = atan2(player.y - y, player.x - x);

    switch(currentState) {
    case IDLE:
      wander();
      if (d < chaseDistance) currentState = State.ATTACK;
      break;

    case ATTACK:
      moveTowardPlayer(player, d);
      if (d > chaseDistance) currentState = State.IDLE;
      break;
    }

    super.update();
  }

  // Behavior helpers

  void moveTowardPlayer(Tank player, float d) {
    if (d > stopDistance) {
      // Move closer until within stopDistance
      angle = turretAngle;
      movingForward = true;
    } else {
      // Stop moving when close enough
      movingForward = false;

      // Shoot
      if (millis() > lastShotTime + shootDelay * (1000/frameRate)) {
        shoot();
        lastShotTime = millis();
      }
    }
  }

  void wander() {
    // Wander when idle
    if (random(1) < 0.01) {
      angle += random(-PI/4, PI/4);
      movingForward = true;
    }
  }

  void shoot() {
    bullets.add(new Bullet(x, y, turretAngle));
    lastShotTime = millis();

    // Recoil
    recoilOffset = recoilMax;

    // Muzzle flash
    pushMatrix();
    translate(x, y);
    rotate(turretAngle);
    noStroke();
    fill(#F5C505);
    ellipse(size * 0.9, 0, 25, 25);
    fill(#F59905);
    ellipse(size * 0.9, 0, 15, 15);
    popMatrix();
  }
}
