import peasy.*;
import controlP5.*;
import processing.opengl.*;

ControlP5 cp5;
PeasyCam cam; 
ControlP5 MyController;

int Max = 5000; // Max Value for a branch
int Length = 7; 
int L = Length; // Length of line for a branch
float Width = L * 0.30; 
float W = Width; // Width if line for a branch
ArrayList<IntList> branches; // Holds all branchs

// red colour
float rOver = 192;
float rChange = 200; 
float rMin = 96;
float rMax = 255;

// green colour
float gOver = 192;
float gChange = 10;
float gMin = 10;
float gMax = 200;

// blue colour
float bOver = 192;
float bChange = 3.5;
float bMin = 96;
float bMax = 255;

// Even angles
float Even_Angles =  PI/6; // default value
float xxisEven = Even_Angles; 
float yxisEven = Even_Angles;
float zxisEven = Even_Angles; 

// Odd angles
float Odd_Angles =  -PI/13; // default value
float xxisOdd = Odd_Angles; 
float yxisOdd = Odd_Angles;
float zxisOdd = Odd_Angles; 
 
void setup() { 
  size(800, 800, P3D); 
  cam = new PeasyCam(this, 700); 
  MyController = new ControlP5(this);
  branches = new ArrayList(); 
  IntList finished = new IntList(); 
  for (int i = Max; i >= 2; i--) {
    // adds branch if not included
    if (!finished.hasValue(i)) {
      IntList branch = collatzBranch(i);
      finished.append(branch);
      branches.add(branch);
    }
  }  
  
  cp5 = new ControlP5(this);

  cp5.addSlider("Even_Angles")
     .setRange(PI/14,PI/3)
     .setValue(Even_Angles)
     .setPosition(10,10)
     .setSize(150,15);  
  
  cp5.addSlider("Odd_Angles")
     .setRange(-PI/14,-PI/3)
     .setValue(Odd_Angles)
     .setPosition(10,30)
     .setSize(150,15);  
   
   cp5.addSlider("Length")
     .setRange(1,10)
     .setValue(Length)
     .setPosition(10,50)
     .setSize(150,15); 
     
   cp5.addSlider("Width")
     .setRange(L * 0.15,L)
     .setValue(Width)
     .setPosition(10,70)
     .setSize(150,15);
     
   cp5.setAutoDraw(false);
     
   println("finished"); 
}  

// draws a branch
void drawBranch(IntList branch) {
  branch.reverse();
  for (int i = 0; i < branch.size(); i++) {
    for (int j = 0; j < 3; j++) {
      if (i < branch.size() - j) {
        int v = branch.get(i + j);
        // even 
        if (v % 2 == 0) {
          if (j == 0) {
            rotateX(xxisEven);
            rOver += rChange;
          } else if (j == 1) {
            rotateY(yxisEven);
            gOver += gChange;
          } else {
            rotateZ(zxisEven);
            bOver += bChange;
          }
        }
        // odd
        else {
          if (j == 0) {
            rotateX(xxisOdd);
            rOver -= rChange;
          } else if (j == 1) {
            rotateY(yxisOdd);
            gOver -= gChange;
          } else {
            rotateZ(zxisOdd);
            bOver -= bChange;
          }
        }
      }
    }
    if (rOver < rMin) rOver = rMin;
    if (rOver > rMax) rOver = rMax;
    if (gOver < gMin) gOver = gMin;
    if (gOver > gMax) gOver = gMax;
    if (bOver < bMin) bOver = bMin;
    if (bOver > bMax) bOver = bMax;
    stroke(rOver,gOver,bOver);
    line(0, 0, 0, -L, 0, 0);
    translate(-L, 0, 0);
  }
}

// draws all branches
void drawBranches(ArrayList<IntList> branches) {
  strokeWeight(W);
  // initial rotations
  rotateY(-PI/2);
  rotateZ(PI/3);
  translate(200, 200, 175);
  for(IntList branch : branches) {
    rOver = 92; 
    gOver = 92; 
    bOver = 92;
    pushMatrix();
    drawBranch(branch.copy());
    popMatrix();
  }
}

// main draw function
void draw() {
  background(0);  
  
  // reset Width 
  W = Width;
  
  // reset Length
  L = Length; 
  
  //reset Even angles
  xxisEven = Even_Angles; 
  yxisEven = Even_Angles;
  zxisEven = Even_Angles; 

  // reset Odd angles
  xxisOdd = Odd_Angles; 
  yxisOdd = Odd_Angles;
  zxisOdd = Odd_Angles; 
  
  stroke(255);
  drawBranches(branches); 
  // drawing then calling the gui allows for it to stay on top of objects
  // drawn before
  gui(); 
}   

// allows sliders to have a gui
void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
} 

// Collatz Algorithem
int collatz(int n) {
  if (n % 2 == 0)
  {
    return n / 2; 
  } 
  else {
    return (n*3+1);
  }
}   

// Implementing the Collatz Algorithem for a specific number
IntList collatzBranch(int n){
  IntList l = new IntList();
  if (n < 2) {
    return l;
  }
  while (n != 1) {
    l.append(n);
    n = collatz(n);
  }
  return l;
}
