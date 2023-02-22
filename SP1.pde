
ArrayList<Circle> circles;
int numOfCircles = 200;
int circleRadiusMax = 10;
int spawnInterval = 5;

void setup() {
    size(512, 512);
    background(255);
    circles = new ArrayList<Circle>();
    circles.add(new Circle(circles.size(), width/2, height/2, 0, 0, circleRadiusMax, width, height));
}

void draw() {
    fill(0);
    stroke(100);
    background(255);
    for (Circle c : circles) {
        c.updateCircle(circles);
        c.drawCircle();
    }
    if(frameRate > 50 && frameCount % spawnInterval == 0){
        circles.add(new Circle(circles.size(), width/5, height/5, (int)random(2,10), 0, (int)random(5,circleRadiusMax), width, height));
    }

}

void mousePressed(){
    exit();
}