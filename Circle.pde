class Circle {
    int key;
    PVector pos;
    PVector vel;
    int boundingBoxXMin, boundingBoxXMax, boundingBoxYMin, boundingBoxYMax;
    int radius;
    float bumpProcentPerSubsetp = 0.1;
    int numSubsteps = 200;
    
    Circle(int key, PVector pos, PVector vel, int radius, int boundingBoxXMin, int boundingBoxXMax, int boundingBoxYMin, int boundingBoxYMax){
        this.key = key;
        this.pos = pos;
        this.vel = vel;
        this.radius = radius;
        this.boundingBoxXMin = boundingBoxXMin;
        this.boundingBoxYMin = boundingBoxYMin;
        this.boundingBoxXMax = boundingBoxXMax;
        this.boundingBoxYMax = boundingBoxYMax;
    }

    Circle(int key, PVector pos, PVector vel, int radius, int canvasWidth, int canvasHeight){
        this(key, pos, vel, radius, 0, canvasWidth, 0, canvasHeight);
    }
    Circle(int key, PVector pos, PVector vel, int canvasWidth, int canvasHeight){
        this(key, pos, vel, 10, 0, canvasWidth, 0, canvasHeight);
    }
    Circle(int key, int posX, int posY, int velX, int velY, int radius, int canvasWidth, int canvasHeight){
        this(key, new PVector(posX, posY), new PVector(velX, velY), radius, 0, canvasWidth, 0, canvasHeight);
    }
    Circle(int key, int posX, int posY, int velX, int velY, int canvasWidth, int canvasHeight){
        this(key, posX, posY, velX, velY, 10, canvasWidth, canvasHeight);
    }

    void drawCircle() {

        ellipse(pos.x, pos.y, radius*2, radius*2);
    }

    //Updates the circle when called
    void updateCircle(ArrayList<Circle> circles){
        vel.add(new PVector(0, 0.1)); // ads gravety
        vel.setMag(vel.mag() * 0.999);

        edegeCollision();
        circleCollision(circles);
        if (vel.mag() > 0.1 ){
            pos.add(vel);
        }
    }
    //Handles the collision with the walls
    private void edegeCollision(){
        if (pos.x + radius > boundingBoxXMax){
            pos.x = boundingBoxXMax - radius;
            vel.x *= -0.5;
        } else if (pos.x - radius < boundingBoxXMin){
            pos.x = boundingBoxXMin + radius;
            vel.x *= -0.5;
        }
        if (pos.y + radius > boundingBoxYMax){
            pos.y = boundingBoxYMax - radius;
            vel.y *= -0.5;
        } else if (pos.y - radius < boundingBoxYMin){
            pos.y = boundingBoxYMin + radius;
            vel.y *= -0.5;
        }
    }

    // This method handles the collision between this Circle and all the circles form the argument
    private void circleCollision(ArrayList<Circle> circles){
        for (Circle c : circles) {
            if(c.key == key){
                continue;
            }
            for (int i = 0; i < numSubsteps; i++) {
                float dist = pos.dist(c.pos);
                if(dist <= radius + c.radius){
                    PVector axis = PVector.sub(c.pos, pos).setMag((radius + c.radius) - dist);
                    c.vel.rotate(PVector.angleBetween(c.vel, axis));
                    vel.rotate(PVector.angleBetween(c.vel, PVector.mult(axis,-1)));
                    if(i < 1){
                        float sharedMag = c.vel.mag() + vel.mag();
                        c.vel.setMag(sharedMag * 0.499);
                        vel.setMag(sharedMag * 0.499);
                    }
                    pos.add(PVector.mult(axis, -bumpProcentPerSubsetp));
                    c.pos.add(PVector.mult(axis, bumpProcentPerSubsetp));
                } else {
                    break;
                }

            }
        }
    }

    @Override
    String toString(){
        return "x: " + pos.x + " y: " + pos.y;
    }
}