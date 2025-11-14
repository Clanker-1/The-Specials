// Main Global variables and core logic by the specials
Tank playerTank;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<EnemyTank> enemies = new ArrayList<EnemyTank>();
ArrayList<Wall> walls = new ArrayList<Wall>();

void setup() {
  size(800, 600);
  rectMode(CENTER);
  imageMode(CENTER);
  
  // Create game objects
  playerTank = new Tank(50, 50, color(50, 150, 50));
  enemies.add(new EnemyTank(750, 550, color(150, 50, 50)));
  
  // Define maze walls (x, y, width, height)
  walls.add(new Wall(width/2, 0, width, 10));      // Top
  walls.add(new Wall(width/2, height, width, 10)); // Bottom
  walls.add(new Wall(0, height/2, 10, height));   // Left
  walls.add(new Wall(width, height/2, 10, height));// Right
  walls.add(new Wall(width/2, height/2, 200, 10)); // Center H
  walls.add(new Wall(width/4, height/2, 10, 100)); // Left V
  walls.add(new Wall(3*width/4, height/4, 10, 150)); // Right V
}

void draw() {
  background(200);

  // Update and display walls
  for (Wall w : walls) {
    w.display();
  }

  // Update and display player tank
  playerTank.update();
  playerTank.checkCollision(walls);
  playerTank.display();

  // Update and display enemies
  for (EnemyTank e : enemies) {
    e.update(playerTank);
    e.checkCollision(walls);
    e.display();
  }

  // Update and display bullets, check collisions
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    // Check bullet collision with walls
    boolean hitWall = false;
    for(Wall w : walls) {
        if (b.checkWallCollision(w)) {
            hitWall = true;
            break;
        }
    }

    // Check bullet collision with tanks
    boolean hitTank = false;
    if (!hitWall) {
      if (b.checkTankCollision(playerTank)) {
          hitTank = true;
      } else {
          for (EnemyTank e : enemies) {
              if (b.checkTankCollision(e)) {
                  hitTank = true;
                  break;
              }
          }
      }
    }
    
    // Remove bullets that go off-screen or hit something
    if (b.isOffScreen() || hitWall || hitTank) {
      bullets.remove(i);
    }
  }
}

void keyPressed() {
  if (key == 'w') playerTank.movingForward = true;
  if (key == 's') playerTank.movingBackward = true;
  if (key == 'a') playerTank.turningLeft = true;
  if (key == 'd') playerTank.turningRight = true;
}

void keyReleased() {
  if (key == 'w') playerTank.movingForward = false;
  if (key == 's') playerTank.movingBackward = false;
  if (key == 'a') playerTank.turningLeft = false;
  if (key == 'd') playerTank.turningRight = false;
}

void mousePressed() {
  if (mouseButton == LEFT) {
    playerTank.shoot();
  }
}

// Wall Class Definition
class Wall {
  float x, y, w, h;

  Wall(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    fill(50, 50, 50);
    noStroke();
    rect(x, y, w, h);
  }
}
